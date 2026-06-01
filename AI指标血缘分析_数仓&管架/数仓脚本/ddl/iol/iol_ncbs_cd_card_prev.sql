/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_card_prev
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_card_prev
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_card_prev purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_prev(
    card_voucher_status varchar2(1) -- 卡凭证状态
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,app_flag varchar2(1) -- 附属卡标志
    ,apply_no varchar2(50) -- 申请编号
    ,batch_job_no varchar2(50) -- 制卡文件批次号
    ,card_cvn varchar2(200) -- 卡片cvn信息
    ,card_medium_type varchar2(1) -- 卡介质类型
    ,card_pb_union_flag varchar2(1) -- 卡折合一标志
    ,card_status varchar2(1) -- 卡状态
    ,change_card_num number(5) -- 换卡次数
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,query_pwd varchar2(200) -- 查询密码
    ,sign_flag varchar2(1) -- 是否记名卡
    ,tread_pwd varchar2(200) -- 交易密码
    ,issue_date date -- 发行日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,valid_from_date date -- 有效期起始日期
    ,valid_thru_date date -- 有效期截止日期
    ,apply_user_id varchar2(8) -- 申请柜员
    ,issue_user_id varchar2(8) -- 发卡柜员
    ,main_card_no varchar2(50) -- 主卡卡号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,card_cvn_mac varchar2(200) -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
    ,valid_thru_date_mac varchar2(200) -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
    ,valid_thru_date_pwd varchar2(200) -- 卡有效期截止日期密文|卡有效期截止日期密文
    ,card_cvn2_mac varchar2(200) -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
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
grant select on ${iol_schema}.ncbs_cd_card_prev to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_card_prev to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_card_prev to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_card_prev to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_card_prev is '卡片基本前置信息表';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_voucher_status is '卡凭证状态';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_no is '卡号';
comment on column ${iol_schema}.ncbs_cd_card_prev.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cd_card_prev.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cd_card_prev.app_flag is '附属卡标志';
comment on column ${iol_schema}.ncbs_cd_card_prev.apply_no is '申请编号';
comment on column ${iol_schema}.ncbs_cd_card_prev.batch_job_no is '制卡文件批次号';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_cvn is '卡片cvn信息';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_medium_type is '卡介质类型';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_pb_union_flag is '卡折合一标志';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_status is '卡状态';
comment on column ${iol_schema}.ncbs_cd_card_prev.change_card_num is '换卡次数';
comment on column ${iol_schema}.ncbs_cd_card_prev.company is '法人';
comment on column ${iol_schema}.ncbs_cd_card_prev.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_cd_card_prev.query_pwd is '查询密码';
comment on column ${iol_schema}.ncbs_cd_card_prev.sign_flag is '是否记名卡';
comment on column ${iol_schema}.ncbs_cd_card_prev.tread_pwd is '交易密码';
comment on column ${iol_schema}.ncbs_cd_card_prev.issue_date is '发行日期';
comment on column ${iol_schema}.ncbs_cd_card_prev.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_card_prev.valid_from_date is '有效期起始日期';
comment on column ${iol_schema}.ncbs_cd_card_prev.valid_thru_date is '有效期截止日期';
comment on column ${iol_schema}.ncbs_cd_card_prev.apply_user_id is '申请柜员';
comment on column ${iol_schema}.ncbs_cd_card_prev.issue_user_id is '发卡柜员';
comment on column ${iol_schema}.ncbs_cd_card_prev.main_card_no is '主卡卡号';
comment on column ${iol_schema}.ncbs_cd_card_prev.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_cvn_mac is '卡CVN信息密文MAC值|卡CVN信息密文MAC值';
comment on column ${iol_schema}.ncbs_cd_card_prev.valid_thru_date_mac is '卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值';
comment on column ${iol_schema}.ncbs_cd_card_prev.valid_thru_date_pwd is '卡有效期截止日期密文|卡有效期截止日期密文';
comment on column ${iol_schema}.ncbs_cd_card_prev.card_cvn2_mac is '卡CVN信息密文MAC值（存储等效二磁信息，包含D的）';
comment on column ${iol_schema}.ncbs_cd_card_prev.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cd_card_prev.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cd_card_prev.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cd_card_prev.etl_timestamp is 'ETL处理时间戳';
