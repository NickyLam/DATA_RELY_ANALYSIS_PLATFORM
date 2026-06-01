/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_tran_desc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_tran_desc
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_tran_desc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_tran_desc(
    remark varchar2(600) -- 备注
    ,card_status varchar2(1) -- 卡状态
    ,cash_flag varchar2(1) -- 现金标志
    ,company varchar2(20) -- 法人
    ,dr_cr_flag varchar2(1) -- 借贷方向标志
    ,message_code varchar2(10) -- 接口服务代码
    ,message_type varchar2(10) -- 接口服务类型
    ,service_type varchar2(10) -- 服务类型
    ,tran_flag varchar2(10) -- 交易标志
    ,tran_name varchar2(200) -- 交易名称
    ,channel varchar2(10) -- 渠道
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cd_tran_desc to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_tran_desc to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_tran_desc to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_tran_desc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_tran_desc is '卡交易信息描述';
comment on column ${iol_schema}.ncbs_cd_tran_desc.remark is '备注';
comment on column ${iol_schema}.ncbs_cd_tran_desc.card_status is '卡状态';
comment on column ${iol_schema}.ncbs_cd_tran_desc.cash_flag is '现金标志';
comment on column ${iol_schema}.ncbs_cd_tran_desc.company is '法人';
comment on column ${iol_schema}.ncbs_cd_tran_desc.dr_cr_flag is '借贷方向标志';
comment on column ${iol_schema}.ncbs_cd_tran_desc.message_code is '接口服务代码';
comment on column ${iol_schema}.ncbs_cd_tran_desc.message_type is '接口服务类型';
comment on column ${iol_schema}.ncbs_cd_tran_desc.service_type is '服务类型';
comment on column ${iol_schema}.ncbs_cd_tran_desc.tran_flag is '交易标志';
comment on column ${iol_schema}.ncbs_cd_tran_desc.tran_name is '交易名称';
comment on column ${iol_schema}.ncbs_cd_tran_desc.channel is '渠道';
comment on column ${iol_schema}.ncbs_cd_tran_desc.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_tran_desc.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cd_tran_desc.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cd_tran_desc.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cd_tran_desc.etl_timestamp is 'ETL处理时间戳';
