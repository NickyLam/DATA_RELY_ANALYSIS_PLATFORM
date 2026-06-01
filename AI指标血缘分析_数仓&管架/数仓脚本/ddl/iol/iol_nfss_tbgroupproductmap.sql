/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbgroupproductmap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbgroupproductmap
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbgroupproductmap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbgroupproductmap(
    group_code varchar2(48) -- 分组代码
    ,ta_code varchar2(27) -- ta代码
    ,prd_code varchar2(48) -- 产品代码
    ,priority number(38) -- 备选产品优先级
    ,redeem_priority number(38) -- 优先级,转出时使用
    ,status varchar2(2) -- 状态
    ,show_priority number(38) -- 展示优先级:展示优先级
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
grant select on ${iol_schema}.nfss_tbgroupproductmap to ${iml_schema};
grant select on ${iol_schema}.nfss_tbgroupproductmap to ${icl_schema};
grant select on ${iol_schema}.nfss_tbgroupproductmap to ${idl_schema};
grant select on ${iol_schema}.nfss_tbgroupproductmap to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbgroupproductmap is '组合宝成分产品信息映射表';
comment on column ${iol_schema}.nfss_tbgroupproductmap.group_code is '分组代码';
comment on column ${iol_schema}.nfss_tbgroupproductmap.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbgroupproductmap.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbgroupproductmap.priority is '备选产品优先级';
comment on column ${iol_schema}.nfss_tbgroupproductmap.redeem_priority is '优先级,转出时使用';
comment on column ${iol_schema}.nfss_tbgroupproductmap.status is '状态';
comment on column ${iol_schema}.nfss_tbgroupproductmap.show_priority is '展示优先级:展示优先级';
comment on column ${iol_schema}.nfss_tbgroupproductmap.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbgroupproductmap.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbgroupproductmap.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbgroupproductmap.etl_timestamp is 'ETL处理时间戳';
