package models

import (
	"database/sql"
	"errors"
	"log"
	"os"
)

type Message struct {
	RecipientID    string // ToDo int?
	RecipientEmail string
	RecipientName  string
	RecipientParam map[string]string
	CampaignID     string // ToDo int?
}

func (m *Message) New(recipientID string) error {
	m.RecipientID = recipientID
	err := Db.QueryRow("SELECT `campaign_id`,`email`,`name` FROM `recipient` WHERE `id`=?", m.RecipientID).Scan(&m.CampaignID, &m.RecipientEmail, &m.RecipientName)
	if err == sql.ErrNoRows {
		return errors.New("The recipient does not exist")
	}
	return nil
}

// Unsubscribe recipient from group
// ToDo move to campaign/Recipient
func (m *Message) Unsubscribe(extra map[string]string) error {
	r, err := Db.Exec("INSERT INTO unsubscribe (`group_id`, `campaign_id`, `email`) VALUE ((SELECT group_id FROM campaign WHERE id=?), ?, ?)", m.CampaignID, m.CampaignID, m.RecipientEmail)
	if err != nil {
		log.Print(err)
	}
	id, e := r.LastInsertId()
	if e != nil {
		log.Print(e)
	}
	for name, value := range extra {
		_, err = Db.Exec("INSERT INTO unsubscribe_extra (`unsubscribe_id`, `name`, `value`) VALUE (?, ?, ?)", id, name, value)
		if err != nil {
			log.Print(err)
		}
	}
	return err
}

// ToDo move to campaign/Recipient
func (m *Message) UnsubscribeTemplateDir() (name string) {
	err := Db.QueryRow("SELECT `group`.`template` FROM `campaign` INNER JOIN `group` ON `campaign`.`group_id`=`group`.`id` WHERE `group`.`template` IS NOT NULL AND `campaign`.`id`=?", m.CampaignID).Scan(&name)
	if err != nil {
		log.Print(err)
	}
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
