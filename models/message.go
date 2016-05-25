// Project Gonder.
// Author Supme
// Copyright Supme 2016
// License http://opensource.org/licenses/MIT MIT License	
//
//  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
//  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
//  PURPOSE.
//
// Please see the License.txt file for more information.
//
package models

import (
	"database/sql"
	"encoding/json"
	"encoding/base64"
	"strings"
	"regexp"
	"text/template"
	"fmt"
	"bytes"
	"errors"
	"os"
)

type (
	Message struct {
		RecipientId string
		RecipientEmail string
		RecipientName string
		RecipientParam map[string]string
		CampaignId string
		CampaignSubject string
		CampaignTemplate string
	}

	JsonData struct {
		Id  string `json:"id"`
		Email string `json:"email"`
		Data string `json:"data"`
	}
)

func (m *Message) New(recipientId string) error {
	m.RecipientId = recipientId
	err := Db.QueryRow("SELECT `campaign_id`,`email`,`name` FROM `recipient` WHERE `id`=?", m.RecipientId).Scan(&m.CampaignId, &m.RecipientEmail, &m.RecipientName)
	if err == sql.ErrNoRows {
		return errors.New("The recipient does not exist")
	}
	return nil
}

func Decode_data(base64data string) (message Message, data string, err error) {
	var param JsonData

	decode, err := base64.URLEncoding.DecodeString(base64data)
	if err != nil {
		return message, data, err
	}
	err = json.Unmarshal([]byte(decode), &param)
	if err != nil {
		return message, data, err
	}
	data = param.Data
	err = message.New(param.Id)
	if err != nil {
		return message, data, err
	}
	if param.Email != message.RecipientEmail {
		return message, data, errors.New("Not valid recipient")
	}
	return message, data, nil
}

func (m *Message) Unsubscribe() error {
	_, err := Db.Exec("INSERT INTO unsubscribe (`group_id`, `campaign_id`, `email`) VALUE ((SELECT group_id FROM campaign WHERE id=?), ?, ?)", m.CampaignId, m.CampaignId, m.RecipientEmail)
	return err
}

func (m *Message) Unsubscribe_template_dir() (name string) {
	Db.QueryRow("SELECT `group`.`template` FROM `campaign` INNER JOIN `group` ON `campaign`.`group_id`=`group`.`id` WHERE `group`.`template` IS NOT NULL AND `campaign`.`id`=?", m.CampaignId).Scan(&name)
	if name == "" {
		name = "default"
	} else {
		if _, err := os.Stat(FromRootDir("templates/" + name + "/accept.html")); err != nil {
			name = "default"
		}
		if _, err := os.Stat(FromRootDir("templates/" + name + "/success.html")); err != nil {
			name = "default"
		}
	}
	name = FromRootDir("templates/" + name)
	return
}

func (m *Message) make_link(cmd, data string) string {
	j, _ := json.Marshal(
		JsonData{
			Id: m.RecipientId,
			Email: m.RecipientEmail,
			Data: data,
		})
	return Config.Url + "/" + cmd + "/" + base64.URLEncoding.EncodeToString(j)
}

func (m *Message) Unsubscribe_web_link() string  {
	return m.make_link("unsubscribe","web")
}

func (m *Message) Unsubscribe_mail_link() string  {
	return m.make_link("unsubscribe","mail")
}

func (m *Message) Redirect_link(url string) string {
	return m.make_link("redirect", url)
}

func (m *Message) Web_link() string {
	return m.make_link("web", "")
}

func (m *Message) StatPng_link() string {
	return m.make_link("open", "")
}

func (m *Message) Render_message() (string, error) {

	var err error
	var web bool

	if m.CampaignSubject == "" && m.CampaignTemplate == "" {
		err := Db.QueryRow("SELECT `subject`,`body` FROM `campaign` WHERE `id`=?", m.CampaignId).Scan(&m.CampaignSubject, &m.CampaignTemplate)
		if err == sql.ErrNoRows {
			return "", err
		}
		web = true
	} else {
		web = false
	}

	m.RecipientParam = map[string]string{}
	var paramKey, paramValue string
	q, err := Db.Query("SELECT `key`, `value` FROM parameter WHERE recipient_id=?", m.RecipientId)
	if err != nil {
		return "", err
	}
	defer q.Close()
	for q.Next() {
		err = q.Scan(&paramKey, &paramValue)
		if err != nil {
			return "", err
		}
		m.RecipientParam[paramKey] = paramValue
	}

	m.RecipientParam["UnsubscribeUrl"] = m.Unsubscribe_web_link()
	m.RecipientParam["StatPng"] = m.StatPng_link()

	if !web {
		m.RecipientParam["WebUrl"] = m.Web_link()

		// add statistic png
		if strings.Index(m.CampaignTemplate, "{{.StatPng}}") == -1 {
			if strings.Index(m.CampaignTemplate, "</body>") == -1 {
				m.CampaignTemplate = m.CampaignTemplate + "<img src='{{.StatPng}}' border='0px' width='10px' height='10px'/>"
			} else {
				m.CampaignTemplate = strings.Replace(m.CampaignTemplate, "</body>", "\n<img src='{{.StatPng}}' border='0px' width='10px' height='10px'/>\n</body>", -1)
			}
		}
	}

	// Replace links for statistic
	re := regexp.MustCompile(`[hH][rR][eE][fF]\s*?=\s*?["']\s*?(\[.*?\])?\s*?(\b[hH][tT]{2}[pP][sS]?\b:\/\/\b)(.*?)["']`)
	m.CampaignTemplate = re.ReplaceAllStringFunc(m.CampaignTemplate, func(str string) string {
		// get only url
		s := strings.Replace(str, `'`, "", -1)
		s = strings.Replace(s, `"`, "", -1)
		s = strings.Replace(s, "href=", "", 1)

		switch s {
		case "{{.WebUrl}}":
			return `href="` + m.RecipientParam["WebUrl"] + `"`
		case "{{.UnsubscribeUrl}}":
			return `href="` + m.RecipientParam["UnsubscribeUrl"] + `"`
		default:
			// template parameter in url
			urlt := template.New("url" + m.RecipientId)
			urlt, err = urlt.Parse(s)
			if err != nil {
				s = fmt.Sprintf("Error parse url params: %v", err)
			}
			u := bytes.NewBufferString("")
			urlt.Execute(u, m.RecipientParam)
			s = u.String()

			return `href="` + m.Redirect_link(s) + `"`
		}
	})

	//replace static url to absolute
	m.CampaignTemplate = strings.Replace(m.CampaignTemplate, "\"/files/", "\"" + Config.Url + "/files/", -1)
	m.CampaignTemplate = strings.Replace(m.CampaignTemplate, "'/files/", "'" + Config.Url + "'/files/", -1)

	tmpl := template.New("mail" + m.RecipientId)

	tmpl, err = tmpl.Parse(m.CampaignTemplate)
	if err != nil {
		e := fmt.Sprintf("Error parse template: %v", err)
		return e, err
	}

	t := bytes.NewBufferString("")
	tmpl.Execute(t, m.RecipientParam)
	return t.String(), nil
}