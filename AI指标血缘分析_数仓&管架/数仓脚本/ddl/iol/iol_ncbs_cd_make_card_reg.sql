/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_make_card_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_make_card_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_make_card_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_make_card_reg(
    area_code varchar2(6) -- 地区码
    ,doc_type varchar2(10) -- 凭证类型
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,apply_no varchar2(50) -- 申请编号
    ,batch_job_no varchar2(50) -- 制卡文件批次号
    ,card_apply_type varchar2(1) -- 制卡申请类型
    ,card_num number(6) -- 制卡数量
    ,company varchar2(20) -- 法人
    ,gain_type varchar2(1) -- 卡片领取方式
    ,lucky_card_flag varchar2(1) -- 是否吉祥卡
    ,make_card_type varchar2(1) -- 制卡类型
    ,make_cd_status varchar2(1) -- 制卡状态
    ,apply_date date -- 申请日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,pick_type varchar2(2) -- 选号类型
    ,receive_flag varchar2(1) -- 签收标志
    ,make_card_date date -- 制卡日期
    ,card_provider varchar2(10) -- 
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
grant select on ${iol_schema}.ncbs_cd_make_card_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_make_card_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_make_card_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_make_card_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_make_card_reg is '制卡申请登记簿';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.area_code is '地区码';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.remark is '备注';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.apply_no is '申请编号';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.batch_job_no is '制卡文件批次号';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.card_apply_type is '制卡申请类型';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.card_num is '制卡数量';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.company is '法人';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.gain_type is '卡片领取方式';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.lucky_card_flag is '是否吉祥卡';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.make_card_type is '制卡类型';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.make_cd_status is '制卡状态';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.apply_date is '申请日期';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.pick_type is '选号类型';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.receive_flag is '签收标志';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.make_card_date is '制卡日期';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.card_provider is '';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cd_make_card_reg.etl_timestamp is 'ETL处理时间戳';
