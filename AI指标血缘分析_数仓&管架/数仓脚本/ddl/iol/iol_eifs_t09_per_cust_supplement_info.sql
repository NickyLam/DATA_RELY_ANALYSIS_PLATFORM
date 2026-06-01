/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t09_per_cust_supplement_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t09_per_cust_supplement_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t09_per_cust_supplement_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t09_per_cust_supplement_info(
    custno varchar2(30) -- 客户号
    ,custle varchar2(383) -- 最近曾用英文名
    ,custlv varchar2(15) -- 客户级别
    ,statlv varchar2(15) -- 当前评级状态
    ,jonttg varchar2(2) -- 联名客户标志
    ,doubtp varchar2(15) -- 疑似客户类型
    ,tttrib number(18,2) -- 综合贡献度
    ,ttrema number(18,2) -- 客户总积分
    ,risklv varchar2(15) -- 风险等级
    ,datatp varchar2(15) -- 数据类型
    ,roletp varchar2(15) -- 参与者类别
    ,isincu varchar2(2) -- 是否系统内客户
    ,iscred varchar2(2) -- 是否授信客户
    ,credid varchar2(15) -- 信用评级id
    ,credln number(18,2) -- 授信额度
    ,prsntp varchar2(2) -- 开卡类型
    ,renatg varchar2(2) -- 实名标识
    ,rgstad varchar2(30) -- 地区代码
    ,sjcate varchar2(2) -- 主体类型
    ,oralla varchar2(90) -- 口语
    ,plvscd varchar2(12) -- 政治面貌
    ,health varchar2(12) -- 健康状况
    ,fvrttx varchar2(383) -- 个人爱好
    ,chartg varchar2(2) -- 个人品质
    ,credre varchar2(2) -- 个人信用记录
    ,fmlynm number(20) -- 家庭总人数
    ,school varchar2(383) -- 毕业院校
    ,insrid varchar2(30) -- 社会保险号
    ,lncdno varchar2(30) -- 贷款卡编号
    ,lncdpw varchar2(12) -- 贷款卡密码
    ,lncdtg varchar2(2) -- 贷款卡状态
    ,lncddt varchar2(12) -- 贷款卡年审日期
    ,lncdst varchar2(12) -- 贷款卡年审结果
    ,lcditg varchar2(2) -- 贷款卡吊销标志
    ,lcdidt varchar2(12) -- 贷款卡吊销日期
    ,lcdrdt varchar2(12) -- 贷款卡恢复日期
    ,incmfy number(18,2) -- 家庭可支配年收入
    ,hmyrpy number(18,2) -- 家庭年支出
    ,gudian varchar2(30) -- 监护人
    ,relatg varchar2(2) -- 是否本行关系人
    ,remark varchar2(383) -- 备注
    ,slrybk varchar2(150) -- 工资帐号开户银行
    ,slryno varchar2(30) -- 工资账号
    ,nwhock number(18,2) -- 现有负债
    ,workyr number(20) -- 当前单位任职年限
    ,workdt varchar2(12) -- 本单位工作起始年份
    ,wkexis varchar2(2) -- 是否有工作单位
    ,limacd varchar2(12) -- 居住地址邮编
    ,homads varchar2(383) -- 居住住址
    ,idadss varchar2(383) -- 户籍地址
    ,hutype varchar2(12) -- 本地户籍类型
    ,hmsupp number(20) -- 
    ,hmasse number(18,2) -- 
    ,identf varchar2(30) -- 客户标识域
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.eifs_t09_per_cust_supplement_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t09_per_cust_supplement_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t09_per_cust_supplement_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t09_per_cust_supplement_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t09_per_cust_supplement_info is '对私补录信息';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.custno is '客户号';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.custle is '最近曾用英文名';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.custlv is '客户级别';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.statlv is '当前评级状态';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.jonttg is '联名客户标志';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.doubtp is '疑似客户类型';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.tttrib is '综合贡献度';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.ttrema is '客户总积分';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.risklv is '风险等级';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.datatp is '数据类型';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.roletp is '参与者类别';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.isincu is '是否系统内客户';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.iscred is '是否授信客户';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.credid is '信用评级id';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.credln is '授信额度';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.prsntp is '开卡类型';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.renatg is '实名标识';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.rgstad is '地区代码';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.sjcate is '主体类型';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.oralla is '口语';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.plvscd is '政治面貌';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.health is '健康状况';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.fvrttx is '个人爱好';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.chartg is '个人品质';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.credre is '个人信用记录';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.fmlynm is '家庭总人数';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.school is '毕业院校';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.insrid is '社会保险号';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lncdno is '贷款卡编号';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lncdpw is '贷款卡密码';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lncdtg is '贷款卡状态';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lncddt is '贷款卡年审日期';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lncdst is '贷款卡年审结果';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lcditg is '贷款卡吊销标志';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lcdidt is '贷款卡吊销日期';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.lcdrdt is '贷款卡恢复日期';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.incmfy is '家庭可支配年收入';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.hmyrpy is '家庭年支出';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.gudian is '监护人';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.relatg is '是否本行关系人';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.remark is '备注';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.slrybk is '工资帐号开户银行';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.slryno is '工资账号';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.nwhock is '现有负债';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.workyr is '当前单位任职年限';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.workdt is '本单位工作起始年份';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.wkexis is '是否有工作单位';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.limacd is '居住地址邮编';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.homads is '居住住址';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.idadss is '户籍地址';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.hutype is '本地户籍类型';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.hmsupp is '';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.hmasse is '';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.identf is '客户标识域';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.last_updated_stamp is '';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.last_updated_tx_stamp is '';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.created_stamp is '';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.created_tx_stamp is '';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t09_per_cust_supplement_info.etl_timestamp is 'ETL处理时间戳';
