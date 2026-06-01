/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fbms_mod_ssc_socialcard_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fbms_mod_ssc_socialcard_info
whenever sqlerror continue none;
drop table ${iol_schema}.fbms_mod_ssc_socialcard_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fbms_mod_ssc_socialcard_info(
    plat_date varchar2(24) -- 平台日期
    ,plat_time varchar2(18) -- 平台时间
    ,plat_serial_no varchar2(120) -- 平台流水号
    ,cust_num varchar2(48) -- 客户号,与客户信息表的客户号关联
    ,city_cd varchar2(18) -- 城市代码,440500-汕头,440300-深圳,
    ,acct_flag varchar2(3) -- 账户模式,1-银行卡号+医保账户,2-银行卡号,
    ,is_physical_card varchar2(3) -- 是否实体卡,0-实体卡,1-无卡账户建立,
    ,merchant varchar2(3) -- 卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚
    ,card_type varchar2(3) -- 卡类别,1-城镇职工,2-城镇居民,3-农村居民
    ,apply_type varchar2(3) -- 申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡
    ,gdcard_reception_nocd varchar2(60) -- 受理网点编码
    ,gdcard_reception_name varchar2(600) -- 受理网点名称
    ,gdcard_claim_formcd varchar2(60) -- 申领表编码
    ,card_version varchar2(12) -- 卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡
    ,social_security_card_num varchar2(105) -- 社保卡号
    ,social_security_num varchar2(150) -- 社会保障号码
    ,post_addr varchar2(900) -- 邮寄地址
    ,financial_cardno varchar2(150) -- 金融卡号（社保卡号）
    ,medicare_cardno varchar2(150) -- 医保卡号
    ,financial_acct varchar2(150) -- 金融账户编号
    ,medicare_acct varchar2(150) -- 医保账户编号
    ,insure_date varchar2(24) -- 制卡日期
    ,insure_time varchar2(18) -- 制卡时间
    ,close_date date -- 销户日期
    ,close_time varchar2(18) -- 销户时间
    ,acct_status_cd varchar2(3) -- 金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
    ,medicare_acct_status_cd varchar2(3) -- 医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
    ,loss_reporting_status varchar2(6) -- 挂失状态,0-正常,1-书面挂失,2-口头挂失
    ,create_timestamp varchar2(60) -- 创建时间戳
    ,update_timestamp varchar2(60) -- 修改时间戳
    ,ext1 varchar2(90) -- 备用字段1
    ,ext2 varchar2(150) -- 备用字段2
    ,is_activation varchar2(3) -- 社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,
    ,activation_msg varchar2(600) -- 省卡返回启用状态信息
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
grant select on ${iol_schema}.fbms_mod_ssc_socialcard_info to ${iml_schema};
grant select on ${iol_schema}.fbms_mod_ssc_socialcard_info to ${icl_schema};
grant select on ${iol_schema}.fbms_mod_ssc_socialcard_info to ${idl_schema};
grant select on ${iol_schema}.fbms_mod_ssc_socialcard_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fbms_mod_ssc_socialcard_info is '社保卡信息表';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.plat_date is '平台日期';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.plat_time is '平台时间';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.plat_serial_no is '平台流水号';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.cust_num is '客户号,与客户信息表的客户号关联';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.city_cd is '城市代码,440500-汕头,440300-深圳,';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.acct_flag is '账户模式,1-银行卡号+医保账户,2-银行卡号,';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.is_physical_card is '是否实体卡,0-实体卡,1-无卡账户建立,';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.merchant is '卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.card_type is '卡类别,1-城镇职工,2-城镇居民,3-农村居民';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.apply_type is '申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.gdcard_reception_nocd is '受理网点编码';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.gdcard_reception_name is '受理网点名称';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.gdcard_claim_formcd is '申领表编码';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.card_version is '卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.social_security_card_num is '社保卡号';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.social_security_num is '社会保障号码';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.post_addr is '邮寄地址';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.financial_cardno is '金融卡号（社保卡号）';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.medicare_cardno is '医保卡号';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.financial_acct is '金融账户编号';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.medicare_acct is '医保账户编号';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.insure_date is '制卡日期';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.insure_time is '制卡时间';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.close_date is '销户日期';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.close_time is '销户时间';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.acct_status_cd is '金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.medicare_acct_status_cd is '医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.loss_reporting_status is '挂失状态,0-正常,1-书面挂失,2-口头挂失';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.update_timestamp is '修改时间戳';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.ext1 is '备用字段1';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.ext2 is '备用字段2';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.is_activation is '社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.activation_msg is '省卡返回启用状态信息';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.start_dt is '开始时间';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.end_dt is '结束时间';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.id_mark is '增删标志';
comment on column ${iol_schema}.fbms_mod_ssc_socialcard_info.etl_timestamp is 'ETL处理时间戳';
