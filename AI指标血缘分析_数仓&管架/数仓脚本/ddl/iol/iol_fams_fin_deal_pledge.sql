/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_deal_pledge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_deal_pledge
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_deal_pledge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_deal_pledge(
    finprod_id varchar2(50) -- 金融产品代码
    ,branch number(10) -- 分支序号
    ,pledge_finprod_id varchar2(50) -- 质押金融产品代码
    ,pledge_face_value number(30,2) -- 质押面值
    ,pledge_number number(30,2) -- 质押数量
    ,pledge_ratio number(30,14) -- 质押率
    ,pledge_amt number(30,2) -- 质押金额
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_fin_deal_pledge to ${iml_schema};
grant select on ${iol_schema}.fams_fin_deal_pledge to ${icl_schema};
grant select on ${iol_schema}.fams_fin_deal_pledge to ${idl_schema};
grant select on ${iol_schema}.fams_fin_deal_pledge to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_deal_pledge is '回购质押品';
comment on column ${iol_schema}.fams_fin_deal_pledge.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_deal_pledge.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_deal_pledge.pledge_finprod_id is '质押金融产品代码';
comment on column ${iol_schema}.fams_fin_deal_pledge.pledge_face_value is '质押面值';
comment on column ${iol_schema}.fams_fin_deal_pledge.pledge_number is '质押数量';
comment on column ${iol_schema}.fams_fin_deal_pledge.pledge_ratio is '质押率';
comment on column ${iol_schema}.fams_fin_deal_pledge.pledge_amt is '质押金额';
comment on column ${iol_schema}.fams_fin_deal_pledge.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_deal_pledge.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_deal_pledge.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_deal_pledge.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_deal_pledge.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_deal_pledge.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_deal_pledge.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_deal_pledge.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_deal_pledge.etl_timestamp is 'ETL处理时间戳';
