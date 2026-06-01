/*
Purpose:    应用集市层-跑数脚本。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py ${batch_date} idl_m_d_coop_conf
CreateDate: 20200618
FileType:   DML
Logs:
    dongyl 2020-06-18 新建表本
*/

truncate table ${idl_schema}.m_d_coop_conf;
insert into ${idl_schema}.m_d_coop_conf values('621469','00','华兴卡','华兴卡','0');
insert into ${idl_schema}.m_d_coop_conf values('623113','01','华兴芯片卡','华兴卡','0');
insert into ${idl_schema}.m_d_coop_conf values('621625','10','公司全能卡','公司全能卡','0');
insert into ${idl_schema}.m_d_coop_conf values('621625','11','中国移动通信集团广东有限公司广州分公司联名卡','兴动卡','1');
insert into ${idl_schema}.m_d_coop_conf values('621625','12','广州南洋理工职业学院校园联名卡','广州南洋理工卡','1');
insert into ${idl_schema}.m_d_coop_conf values('621625','13','Fit卡','Fit卡','0');
insert into ${idl_schema}.m_d_coop_conf values('621625','14','东江畜牧卡','东江畜牧卡','1');
insert into ${idl_schema}.m_d_coop_conf values('623688','01','金融IC借记卡','华兴卡','0');
insert into ${idl_schema}.m_d_coop_conf values('623688','02','招财猫e账户','招财猫e账户','0');
insert into ${idl_schema}.m_d_coop_conf values('623688','03','天猫账户','天猫账户','1');
insert into ${idl_schema}.m_d_coop_conf values('623688','04','移动tsm账户','移动tsm账户','0');
insert into ${idl_schema}.m_d_coop_conf values('623113','05','同程旅游联名卡','同程联名卡','1');
insert into ${idl_schema}.m_d_coop_conf values('623113','06','亚太联名卡','亚太联名卡','1');
insert into ${idl_schema}.m_d_coop_conf values('623113','07','网协联名卡','网协联名卡','1');
insert into ${idl_schema}.m_d_coop_conf values('623113','14','东江畜牧卡','东江畜牧卡','1');
commit;