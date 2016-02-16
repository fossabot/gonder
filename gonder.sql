SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `attachment` (
`id` int(11) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `path` text NOT NULL,
  `file` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `campaign` (
`id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL,
  `from` text NOT NULL,
  `from_name` text NOT NULL,
  `name` text NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `group` (
`id` int(11) NOT NULL,
  `name` text NOT NULL,
  `template` text
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `jumping` (
`id` int(11) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `url` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `parameter` (
`id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `key` text NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `profile` (
`id` int(11) NOT NULL,
  `name` text NOT NULL,
  `iface` text NOT NULL COMMENT 'Example: xx.xx.xx.xx or socks://ip:port for socks5. Blank for default interface.',
  `host` text NOT NULL COMMENT 'The name of the server on behalf of which there is a sending.',
  `stream` int(11) NOT NULL COMMENT 'Number of concurrent streams',
  `delay` int(11) NOT NULL COMMENT 'Delay between one time stream in seconds'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `recipient` (
`id` int(11) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `email` text NOT NULL,
  `name` text NOT NULL,
  `status` text,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_agent` text,
  `web_agent` text
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `unsubscribe` (
`id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `email` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `status` (
  `id` int(3) NOT NULL,
  `pattern` varchar(250) NOT NULL,
  `bounce_id` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `status` (`id`, `pattern`, `bounce_id`) VALUES
(4, 'OK', 1),
(5, 'UNSUBSCRIBE', 1),
(6, 'TEST SEND', 1),
(7, 'CONNECTION REFUSED', 2),
(8, 'LOOPS BACK TO MYSELF', 2),
(9, '501 SYNTAX ERROR IN PARAMETERS OR ARGUMENTS', 2),
(10, 'ESMTP SERVER NOT AVAILABLE', 2),
(11, 'SMTP AUTHENTICATION IS REQUIRED', 2),
(12, 'INVALID RDNS ENTRY FOR', 2),
(13, 'YOU ARE USING INCORRECT SERVER FOR OUTGOING', 2),
(14, 'NO MAIL WILL BE ACCEPTED', 2),
(15, 'PLEASE USE YOUR PROVIDER SMTP', 2),
(16, 'RDNS IS ABSENT', 2),
(17, 'REVERSE LOOKUP FAILED', 2),
(18, 'MAILSERVER WITHOUT A VALID PTR', 2),
(19, 'REMOTE SENDING ONLY ALLOWED WITH AUTHENTICATION', 2),
(20, 'CLIENT HOST REJECTED', 2),
(21, 'I\'M SORRY, THIS MESSAGE COULD NOT BE RECEIVED.', 2),
(22, 'PLEASE TRY ANOTHER SERVER', 2),
(23, 'OUR SYSTEM HAS DETECTED THAT THIS MESSAGE IS', 2),
(24, 'OPENRELAY OR DIALUP', 2),
(25, 'FUCKOFF, WE DONT WANT MAIL FROM YOU', 2),
(26, 'SERVER PERMANENTLY REJECTED MESSAGE', 2),
(27, 'COMMAND NOT ALLOWED', 2),
(28, 'MESSAGE REJECTED', 2),
(29, 'COMMAND REJECTED', 2),
(30, 'REFUSED', 2),
(31, 'SPAM', 2),
(32, 'TEMPORARILY DEFERRED', 2),
(33, 'SENDER DENIED', 2),
(34, 'BLACKLIST', 2),
(35, 'BLACK LIST', 2),
(36, 'BLOCKED', 2),
(37, 'BANNED', 2),
(38, 'HAS EXCEEDED MAXIMUM ATTACHMENT COUNT LIMIT', 2),
(39, 'MESSAGE HELD FOR HUMAN VERIFICATION', 2),
(40, 'MESSAGE HELD BEFORE PERMITTING DELIVERY', 2),
(41, 'MESSAGE CONTAINS UNACCEPTABLE ATTACHMENT', 2),
(42, 'QUOTA EXCEEDED', 2),
(43, 'FULL', 2),
(44, 'OVER QUOTA', 2),
(45, 'QUOTA EXCEED', 2),
(46, 'MAILBOX SIZE EXCEEDED', 2),
(47, 'MAILBOX HAS EXCEEDED THE LIMIT', 2),
(48, 'IS NOT YET AUTHORIZED', 2),
(49, 'ADDRESS VERIFICATION IN PROGRESS', 2),
(50, 'EXCEEDED STORAGE ALLOCATION', 2),
(51, 'OVER MAIL QUOTA', 2),
(52, 'PERMANENT FAILURE, USER IS OVER QUOTE', 2),
(53, 'GREYLIST', 2),
(54, 'HTTP://UKR.NET/MTA/STD3.HTML', 2),
(55, 'TRY AGAIN LATER', 2),
(56, 'TRY LATER', 2),
(57, 'COME BACK LATER', 2),
(58, 'SERVICE UNAVAILABLE', 2),
(59, 'INTERNAL SOFTWARE ERROR', 2),
(60, 'LOCAL VERIFICATION PROBLEM', 2),
(61, 'SERVICE IS CURRENTLY UNAVAILABLE', 2),
(62, 'SERVICE NOT AVAILABLE', 2),
(63, 'VERIFICATION FAILED', 2),
(64, 'ABORTED BY TIMEOUT', 2),
(65, 'INTERRUPTED SYSTEM CALL', 2),
(66, 'TIME TO LIVE EXPIRED', 2),
(67, 'TIMEOUT WAITING FOR CLIENT INPUT', 2),
(68, 'SERVICE CURRENTLY UNAVAILABLE', 2),
(69, 'INTERNAL RESOURCE TEMPORARILY UNAVAILABLE', 2),
(70, 'INTERNAL SYSTEM ERROR', 2),
(71, 'TEMPORARY ERROR', 2),
(72, 'TEMPORARY LOCAL PROBLEM', 2),
(73, '554 TRANSACTION FAILED', 2),
(74, 'DNS TIMEOUT', 2),
(75, 'TEMPORARY FAILURE', 2),
(76, 'INTERNAL ERROR', 2),
(77, 'RATE LIMIT EXCEEDED', 2),
(78, 'TEMPORARY LOOKUP FAILURE', 2),
(79, 'REQUESTED ACTION ABORTED', 2),
(80, 'QUEUE FILE WRITE ERROR', 2),
(81, 'QQQ READ ERROR', 2),
(82, 'RESOURCES TEMPORARILY UNAVAILABLE', 2),
(83, 'ACCESS DENIED', 2),
(84, 'PERMISSION DENIED', 2),
(85, 'AUTHENTICATION REQUIRED', 2),
(86, 'AUTHORIZATION CHECK FAILED', 2),
(87, 'NOT ACCEPTING MAIL WITH ATTACHMENTS OR EMBEDDED IMAGES', 2),
(88, 'ADMINISTRATIVE PROHIBITION', 2),
(89, 'REJECTED BY ADMINISTRATIVE POLICY', 2),
(90, 'CONNECTION REJECTED BY POLICY', 2),
(91, 'POLICY REJECTION', 2),
(92, 'DOES NOT HAVE PERMISSIONS', 2),
(93, 'REJECTED FOR POLICY REASONS', 2),
(94, 'DENIED BY POLICY', 2),
(95, 'LOCAL POLICY VIOLATION', 2),
(96, 'MESSAGE VIOLATES OUR EMAIL POLICY', 2),
(97, 'ACCEPT MAIL ONLY FROM OUR WHITE LIST OF AUTHORIZED ADDRESSES', 2),
(98, 'MESSAGE CANNOT BE ACCEPTED, RULES REJECTION', 2),
(99, 'SORRY, THAT ADDRESS IS NOT IN MY LIST OF ALLOWED RECIPIENTS', 2),
(100, 'ONLY LOCAL MAIL. SORRY', 2),
(101, 'REVERSE DNS LOOKUP FAILED', 2),
(102, 'DNS PTR MISMATCH', 2),
(103, 'DNS ERROR', 2),
(104, 'DNS VALIDATION FAILED', 2),
(105, 'DNS MX LOOKUP FAILED', 2),
(106, 'DNS SERVER FAILURE', 2),
(107, 'NO REVERSE DNS', 2),
(108, 'BAD REVERSE DNS', 2),
(109, 'SPF STRONG CHECK FAILED', 2),
(110, 'SPF FORGERY FOR SENDER', 2),
(111, 'SPF CHECK FAILED', 2),
(112, 'SORRY, THAT DOMAIN ISN\'T ALLOWED TO BE RELAYED THRU THIS MTA', 2),
(113, 'NO UNAUTHENTICATED RELAYING PERMITTED', 2),
(114, 'RELAY ACCESS DENIED', 2),
(115, 'WE DO NOT RELAY', 2),
(116, 'NO RELAYING ALLOWED', 2),
(117, 'RELAYING DENIED', 2),
(118, 'RELAY DENIED FOR', 2),
(119, 'NOT PERMITTED TO RELAY THROUGH THIS SERVER', 2),
(120, 'RELAY NOT PERMITTED', 2),
(121, 'RELAYING NOT ALLOWED', 2),
(122, 'IS CURRENTLY NOT PERMITTED TO RELAY', 2),
(123, 'UNABLE TO RELAY FOR', 2),
(124, 'AUTHENTICATION REQUIRED FOR RELAY', 2),
(125, 'UNABLE TO RELAY', 2),
(126, '(RELAYING) IS NOT ALLOWED', 2),
(127, 'SENDER IS SPOOFED', 2),
(128, 'SENDER IS DOUBT', 2),
(129, 'RATELIMIT EXCEEDED', 2),
(130, 'TOO MANY CONNECTIONS', 2),
(131, 'TOO MUCH MAIL', 2),
(132, 'VERY FAST', 2),
(133, 'NOT SO FAST', 2),
(134, 'UNUSUAL RATE OF', 2),
(135, 'TOO MANY RECIPIENTS', 2),
(136, 'TOO MANY HOPS', 2),
(137, 'HOP COUNT EXCEEDED', 2),
(138, 'STOP FOR A SHORT TIME', 2),
(139, 'HOST_LOOKUP_FAILED', 2),
(140, 'CANNOT FIND YOUR HOSTNAME', 2),
(141, 'DOMAIN MUST RESOLVE', 2),
(142, 'HOSTNAME MUST RESOLVE', 2),
(143, 'HOST HAVE BAD REVERSE ZONE', 2),
(144, 'IP NAME LOOKUP FAILED', 2),
(145, 'NO HOST NAME FOUND FOR IP ADDRESS', 2),
(146, 'THERE IS NO REVERSE (PTR) RECORD FOUND FOR YOUR HOST', 2),
(147, 'YOUR HOST NAME DOSEN\'T MATCH WITH YOUR IP ADDRESS', 2),
(148, 'IP NAME FORGED', 2),
(149, 'INVALID EHLO/HELO DOMAIN', 2),
(150, 'WRONG HELO', 2),
(151, 'BAD HELO/EHLO', 2),
(152, 'HELO HOST NAME INVALID', 2),
(153, 'POSSIBLY FORGED HOSTNAME', 2),
(154, 'HELO COMMAND REJECTED: NEED FULLY-QUALIFIED HOSTNAME', 2),
(155, 'NEED FULLY-QUALIFIED HOSTNAME', 2),
(156, '5.1.1', 3),
(157, '5.1.0', 3),
(158, 'BAD ADDRESS', 3),
(159, 'USER UNKNOWN', 3),
(160, 'MAILBOX UNAVAILABLE', 3),
(161, 'NO SUCH USER', 3),
(162, 'NOSUCHUSER', 3),
(163, 'DOES NOT EXIST', 3),
(164, 'UNKNOWN USER', 3),
(165, 'UNKNOWN IN VIRTUAL MAILBOX', 3),
(166, 'THIS USER DOESN\'T HAVE A YAHOO.COM ACCOUNT', 3),
(167, 'NO MAILBOX', 3),
(168, 'INVALID RECIPIENT', 3),
(169, 'USER UNKNOWN IN VIRTUAL ALIAS TABLE', 3),
(170, 'USER DOES NOT EXIST', 3),
(171, 'NO EXIST', 3),
(172, 'RECIPIENT UNKNOWN', 3),
(173, 'MAILBOX NOT FOUND', 3),
(174, 'INVALID ADDRESS', 3),
(175, 'NO SUCH PERSON AT THIS ADDRESS', 3),
(176, 'REMOTE HOST SAID: 553', 3),
(177, 'NO ONE HERE BY THAT NAME', 3),
(178, 'NOT LISTED IN DOMINO DIRECTORY', 3),
(179, 'USER IS UNKNOWN', 3),
(180, 'NO SUCH ADDRESS', 3),
(181, 'USER NOT FOUND', 3),
(182, 'UNKNOWN OR ILLEGAL ALIAS', 3),
(183, 'BAD DESTINATION EMAIL ADDRESS', 3),
(184, 'NOT OUR CUSTOMER', 3),
(185, 'USER INVALID', 3),
(186, 'CALLOUT VERIFICATION FAILURE', 3),
(187, 'RECIPIENT IS NOT EXIST', 3),
(188, 'NOT A VALID MAILBOX', 3),
(189, 'RCPT ACCOUNT ISN\'T A LOCAL ACCOUNT', 3),
(190, 'NOT KNOWN HERE', 3),
(191, 'MAILDIR DELIVERY FAILED', 3),
(192, 'UNKNOWN RECIPIENT', 3),
(193, 'INVALID USER', 3),
(194, 'NO SUCH MAILBOX', 3),
(195, 'NO ACCOUNT BY THAT NAME HERE', 3),
(196, 'NO SUCH RECIPIENT', 3),
(197, 'USER NOT EXIST', 3),
(198, 'NO MAILBOX BY THAT NAME IS CURRENTLY AVAILABLE', 3),
(199, 'ADDRESS UNKNOWN', 3),
(200, 'DOES NOT LIKE RECIPIENT', 3),
(201, 'USER NOT KNOWN', 3),
(202, 'UNABLE TO DELIVER TO', 3),
(203, 'NO USER FOUND', 3),
(204, 'NO VALID RECIPIENTS', 3),
(205, 'NOT A VALID USER', 3),
(206, 'EMAIL ACCOUNT THAT YOU TRIED TO REACH DOES NO EXISTS', 3),
(207, 'ADDRESS INVALID', 3),
(208, 'USER UNKNOWN', 3),
(209, 'ADDRESSES FAILED', 3),
(210, 'ACCOUNT UNAVAILABLE', 3),
(211, 'USER DOESN\'T HAVE A YAHOO', 3),
(212, 'IN MY MAILSERVER NOT STORED THIS USER', 3),
(213, 'RECIPIENT ADDRESS ROUTE FAILED', 3),
(214, 'BAD ADDRESS SYNTAX', 3),
(215, 'BAD DESTINATION MAILBOX ADDRESS', 3),
(216, 'FAILED TO ROUTE THE ADDRESS', 3),
(217, 'NO SUCH ADDRES HERE', 3),
(218, 'NO SUCH LOCAL USER', 3),
(219, 'DOESN\'T HAVE A YMAIL.COM ACCOUNT', 3),
(220, 'FUNNY RECIPIENT', 3),
(221, 'WAS NOT FOUND IN LDAP SERVER', 3),
(222, 'RECIPIENT NOT FOUND', 3),
(223, 'RECIPIENT NOT FOUND', 3),
(224, 'UNKNOWN LOCAL PART TATIANA.AZAROVA IN', 3),
(225, 'DOMAIN MUST RESOLVE', 3),
(226, 'UNROUTABLE ADDRESS', 3),
(227, 'NO SUCH DOMAIN AT THIS LOCATION', 3),
(228, 'CONNECTION FAILED: 500 HOST NAME IS UNKNOWN', 3),
(229, 'CONNECTION FAILED: 500 HOST NOT FOUND', 3),
(230, 'RETURN 0 MX RECORDS', 3),
(231, 'NAME SERVICE ERROR', 3),
(232, 'UNROUTEABLE ADDRESS', 3),
(233, 'NO ROUTE TO HOST', 3),
(234, 'ALL RELEVANT MX RECORDS POINT TO NON-EXISTENT HOSTS', 3),
(235, 'UNABLE TO CONNECT SUCCESSFULLY TO THE DESTINATION MAIL SERVER', 3),
(236, 'HOST UNREACHABLE', 3),
(237, 'MAILBOX DISABLED', 3),
(238, 'ACCOUNT DISABLED', 3),
(239, 'DISABLED', 3),
(240, 'THIS ACCOUNT HAS BEEN DISABLED OR DISCONTINUED', 3),
(241, 'IS DISABLED', 3),
(242, 'THE USER\'S MAILBOX IS NOT AVAILABLE', 3),
(243, 'INACTIVE USER', 3),
(244, 'ACCOUNT INACTIVE', 3),
(245, 'IS NO LONGER ACTIVE', 3),
(246, 'USER DISABLED', 3),
(247, 'THIS ADDRESS NO LONGER ACCEPTS MAIL', 3),
(248, 'RECIPIENT BLOCKED', 3),
(249, 'ACCOUNT IS DISABLED', 3),
(250, 'ACCOUNT HAS BEEN SUSPENDED', 3),
(251, 'MAIL RECEIVING DISABLED', 3),
(252, 'ACCOUNT LOCKED', 3),
(253, 'NO RECIPIENT ACTIVITY SINCE', 3),
(254, 'MAILBOX CURRENTLY SUSPENDED', 3),
(255, 'MAILBOX IS FROZEN', 3),
(256, 'USER INACTIVE', 3),
(257, 'DOMAIN DISABLED', 3),
(258, 'MAILBOX LOCKED', 3),
(259, 'MAILBOX IS BLOCKED', 3),
(260, 'ACCOUNT CLOSED', 3),
(261, 'ACCOUNT DELETED BY USER', 3),
(262, 'USER IS TERMINATED', 3);


ALTER TABLE `attachment`
 ADD PRIMARY KEY (`id`), ADD KEY `campaign_id` (`campaign_id`);

ALTER TABLE `campaign`
 ADD PRIMARY KEY (`id`), ADD KEY `group_id` (`group_id`), ADD KEY `profile_id` (`profile_id`);

ALTER TABLE `group`
 ADD PRIMARY KEY (`id`);

ALTER TABLE `jumping`
 ADD PRIMARY KEY (`id`), ADD KEY `campaign_id` (`campaign_id`), ADD KEY `recipient_id` (`recipient_id`);

ALTER TABLE `parameter`
 ADD PRIMARY KEY (`id`), ADD KEY `recipient_id` (`recipient_id`);

ALTER TABLE `profile`
 ADD PRIMARY KEY (`id`);

ALTER TABLE `recipient`
 ADD PRIMARY KEY (`id`), ADD KEY `campaign_id` (`campaign_id`);

ALTER TABLE `unsubscribe`
 ADD PRIMARY KEY (`id`), ADD KEY `group_id` (`group_id`), ADD KEY `campaign_id` (`campaign_id`);

ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `attachment`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `campaign`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `group`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `jumping`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `parameter`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `profile`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `recipient`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `unsubscribe`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
ALTER TABLE `status`
MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;

ALTER TABLE `attachment`
ADD CONSTRAINT `attachment_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaign` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `jumping`
ADD CONSTRAINT `jumping_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaign` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `jumping_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `recipient` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `parameter`
ADD CONSTRAINT `parameter_ibfk_1` FOREIGN KEY (`recipient_id`) REFERENCES `recipient` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `recipient`
ADD CONSTRAINT `recipient_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaign` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
