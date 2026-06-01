/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_voucher
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_voucher
whenever sqlerror continue none;
drop table ${iml_schema}.agt_voucher purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_voucher(
    vouch_id varchar2(60) -- 凭证编号
    ,lp_id varchar2(60) -- 法人编号
    ,vouch_type_cd varchar2(10) -- 凭证类型代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
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
grant select on ${iml_schema}.agt_voucher to ${icl_schema};
grant select on ${iml_schema}.agt_voucher to ${idl_schema};
grant select on ${iml_schema}.agt_voucher to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_voucher is '凭证';
comment on column ${iml_schema}.agt_voucher.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_voucher.lp_id is '法人编号';
comment on column ${iml_schema}.agt_voucher.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.agt_voucher.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_voucher.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_voucher.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_voucher.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_voucher.create_dt is '创建日期';
comment on column ${iml_schema}.agt_voucher.update_dt is '更新日期';
comment on column ${iml_schema}.agt_voucher.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_voucher.id_mark is '增删标志';
comment on column ${iml_schema}.agt_voucher.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_voucher.job_cd is '任务编码';
comment on column ${iml_schema}.agt_voucher.etl_timestamp is 'ETL处理时间戳';
