/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bill_blank_vouch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bill_blank_vouch
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bill_blank_vouch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_blank_vouch(
    vouch_id varchar2(100) -- 凭证编号
    ,lp_id varchar2(100) -- 法人编号
    ,dtl_id varchar2(100) -- 明细编号
    ,batch_id varchar2(100) -- 批次编号
    ,bill_num varchar2(100) -- 票据号码
    ,vouch_status_cd varchar2(30) -- 凭证状态代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_bill_blank_vouch to ${icl_schema};
grant select on ${iml_schema}.agt_bill_blank_vouch to ${idl_schema};
grant select on ${iml_schema}.agt_bill_blank_vouch to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bill_blank_vouch is '票据空白凭证';
comment on column ${iml_schema}.agt_bill_blank_vouch.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_bill_blank_vouch.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bill_blank_vouch.dtl_id is '明细编号';
comment on column ${iml_schema}.agt_bill_blank_vouch.batch_id is '批次编号';
comment on column ${iml_schema}.agt_bill_blank_vouch.bill_num is '票据号码';
comment on column ${iml_schema}.agt_bill_blank_vouch.vouch_status_cd is '凭证状态代码';
comment on column ${iml_schema}.agt_bill_blank_vouch.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_bill_blank_vouch.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_bill_blank_vouch.create_dt is '创建日期';
comment on column ${iml_schema}.agt_bill_blank_vouch.update_dt is '更新日期';
comment on column ${iml_schema}.agt_bill_blank_vouch.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_bill_blank_vouch.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bill_blank_vouch.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bill_blank_vouch.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bill_blank_vouch.etl_timestamp is 'ETL处理时间戳';
