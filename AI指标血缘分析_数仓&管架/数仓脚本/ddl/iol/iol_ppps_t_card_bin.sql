/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_t_card_bin
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_t_card_bin
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_t_card_bin purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_card_bin(
    id number(22) -- 自增主键
    ,card_bin varchar2(12) -- 卡BIN
    ,card_length number(22) -- 卡号长度
    ,acct_type varchar2(30) -- 卡类型，取值：AcctTypeEnum
    ,clear_bank_code varchar2(48) -- 清算行行号
    ,clear_bank_name varchar2(72) -- 清算行行名
    ,active varchar2(10) -- 起停状态，取值：ActiveStateEnum
    ,create_time date -- 创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time date -- 最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,financial_branch_code varchar2(30) -- 金融机构代码"
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
grant select on ${iol_schema}.ppps_t_card_bin to ${iml_schema};
grant select on ${iol_schema}.ppps_t_card_bin to ${icl_schema};
grant select on ${iol_schema}.ppps_t_card_bin to ${idl_schema};
grant select on ${iol_schema}.ppps_t_card_bin to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_t_card_bin is '卡BIN信息维护表';
comment on column ${iol_schema}.ppps_t_card_bin.id is '自增主键';
comment on column ${iol_schema}.ppps_t_card_bin.card_bin is '卡BIN';
comment on column ${iol_schema}.ppps_t_card_bin.card_length is '卡号长度';
comment on column ${iol_schema}.ppps_t_card_bin.acct_type is '卡类型，取值：AcctTypeEnum';
comment on column ${iol_schema}.ppps_t_card_bin.clear_bank_code is '清算行行号';
comment on column ${iol_schema}.ppps_t_card_bin.clear_bank_name is '清算行行名';
comment on column ${iol_schema}.ppps_t_card_bin.active is '起停状态，取值：ActiveStateEnum';
comment on column ${iol_schema}.ppps_t_card_bin.create_time is '创建时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_card_bin.update_time is '最后更新时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_card_bin.financial_branch_code is '金融机构代码"';
comment on column ${iol_schema}.ppps_t_card_bin.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_t_card_bin.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_t_card_bin.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_t_card_bin.etl_timestamp is 'ETL处理时间戳';
