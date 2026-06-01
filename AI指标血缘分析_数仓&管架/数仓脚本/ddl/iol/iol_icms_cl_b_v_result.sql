/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_b_v_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_b_v_result
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_b_v_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_b_v_result(
    totalpaymentinner number(24,6) -- 累计放款内部)
    ,businessno varchar2(64) -- 业务编号
    ,totalrepaymentinner number(24,6) -- 累计还款内部)
    ,isdeal varchar2(2) -- 是否已处理
    ,totalrepaymentout number(24,6) -- 累计还款外部)
    ,updatedate date -- 处理日期
    ,exposurebalanceinner number(24,6) -- 敞口余额内部)
    ,updateuserid varchar2(64) -- 处理人
    ,totalpaymentout number(24,6) -- 累计放款外部)
    ,updateorgid varchar2(64) -- 处理机构
    ,nominalbalanceinner number(24,6) -- 名义余额内部)
    ,balanceupdatetimeout date -- 余额更新时间外部)
    ,balanceupdatetimeinner date -- 余额更新时间内部)
    ,serialno varchar2(64) -- 流水号
    ,relaserialno varchar2(64) -- 关联流水号
    ,exposurebalanceout number(24,6) -- 敞口余额外部)
    ,nominalbalanceout number(24,6) -- 名义余额外部)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_cl_b_v_result to ${iml_schema};
grant select on ${iol_schema}.icms_cl_b_v_result to ${icl_schema};
grant select on ${iol_schema}.icms_cl_b_v_result to ${idl_schema};
grant select on ${iol_schema}.icms_cl_b_v_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_b_v_result is '业务对账结果表';
comment on column ${iol_schema}.icms_cl_b_v_result.totalpaymentinner is '累计放款内部)';
comment on column ${iol_schema}.icms_cl_b_v_result.businessno is '业务编号';
comment on column ${iol_schema}.icms_cl_b_v_result.totalrepaymentinner is '累计还款内部)';
comment on column ${iol_schema}.icms_cl_b_v_result.isdeal is '是否已处理';
comment on column ${iol_schema}.icms_cl_b_v_result.totalrepaymentout is '累计还款外部)';
comment on column ${iol_schema}.icms_cl_b_v_result.updatedate is '处理日期';
comment on column ${iol_schema}.icms_cl_b_v_result.exposurebalanceinner is '敞口余额内部)';
comment on column ${iol_schema}.icms_cl_b_v_result.updateuserid is '处理人';
comment on column ${iol_schema}.icms_cl_b_v_result.totalpaymentout is '累计放款外部)';
comment on column ${iol_schema}.icms_cl_b_v_result.updateorgid is '处理机构';
comment on column ${iol_schema}.icms_cl_b_v_result.nominalbalanceinner is '名义余额内部)';
comment on column ${iol_schema}.icms_cl_b_v_result.balanceupdatetimeout is '余额更新时间外部)';
comment on column ${iol_schema}.icms_cl_b_v_result.balanceupdatetimeinner is '余额更新时间内部)';
comment on column ${iol_schema}.icms_cl_b_v_result.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_b_v_result.relaserialno is '关联流水号';
comment on column ${iol_schema}.icms_cl_b_v_result.exposurebalanceout is '敞口余额外部)';
comment on column ${iol_schema}.icms_cl_b_v_result.nominalbalanceout is '名义余额外部)';
comment on column ${iol_schema}.icms_cl_b_v_result.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_b_v_result.etl_timestamp is 'ETL处理时间戳';
