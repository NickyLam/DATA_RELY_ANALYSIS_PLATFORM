/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_product_pledge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_product_pledge
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_product_pledge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_pledge(
    id varchar2(72) -- 主键
    ,finprod_id varchar2(100) -- 金融产品代码(关联FIN_PRODUCT)
    ,pledge_type varchar2(100) -- 抵质押物类型
    ,pledge_id varchar2(400) -- 抵质押物账号（抵质押合同号）
    ,pledge_amt number(30,2) -- 抵质押物金额（估值）
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,val_date date -- 估值日期
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_fin_product_pledge to ${iml_schema};
grant select on ${iol_schema}.fams_fin_product_pledge to ${icl_schema};
grant select on ${iol_schema}.fams_fin_product_pledge to ${idl_schema};
grant select on ${iol_schema}.fams_fin_product_pledge to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_product_pledge is '质押品管理数据信息表';
comment on column ${iol_schema}.fams_fin_product_pledge.id is '主键';
comment on column ${iol_schema}.fams_fin_product_pledge.finprod_id is '金融产品代码(关联FIN_PRODUCT)';
comment on column ${iol_schema}.fams_fin_product_pledge.pledge_type is '抵质押物类型';
comment on column ${iol_schema}.fams_fin_product_pledge.pledge_id is '抵质押物账号（抵质押合同号）';
comment on column ${iol_schema}.fams_fin_product_pledge.pledge_amt is '抵质押物金额（估值）';
comment on column ${iol_schema}.fams_fin_product_pledge.vdate is '起息日';
comment on column ${iol_schema}.fams_fin_product_pledge.mdate is '到期日';
comment on column ${iol_schema}.fams_fin_product_pledge.val_date is '估值日期';
comment on column ${iol_schema}.fams_fin_product_pledge.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_product_pledge.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_product_pledge.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_product_pledge.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_product_pledge.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_product_pledge.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_product_pledge.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_product_pledge.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_product_pledge.etl_timestamp is 'ETL处理时间戳';
