/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ptl_sec_position
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ptl_sec_position
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ptl_sec_position purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_sec_position(
    portfolio_id varchar2(32) -- 组合代码
    ,sec_acct_id varchar2(32) -- 证券管理账户/通道代码，无通道无证券管理账户的存999999
    ,finprod_id varchar2(50) -- 金融产品代码
    ,branch number(10) -- 分支序号
    ,inv_aim varchar2(50) -- 投资目的，无投资目的的存999999
    ,hoding_type varchar2(50) -- 持仓类型，实际、在途、质押、融入、融出
    ,cdate date -- 日期
    ,amount number(30,4) -- 数量
    ,ccy varchar2(50) -- 币种，资产对应的币种
    ,p_finprod_id varchar2(50) -- 母金融产品代码
    ,face_value number(30,14) -- 百元面值
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
grant select on ${iol_schema}.fams_ptl_sec_position to ${iml_schema};
grant select on ${iol_schema}.fams_ptl_sec_position to ${icl_schema};
grant select on ${iol_schema}.fams_ptl_sec_position to ${idl_schema};
grant select on ${iol_schema}.fams_ptl_sec_position to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ptl_sec_position is '组合持仓';
comment on column ${iol_schema}.fams_ptl_sec_position.portfolio_id is '组合代码';
comment on column ${iol_schema}.fams_ptl_sec_position.sec_acct_id is '证券管理账户/通道代码，无通道无证券管理账户的存999999';
comment on column ${iol_schema}.fams_ptl_sec_position.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_ptl_sec_position.branch is '分支序号';
comment on column ${iol_schema}.fams_ptl_sec_position.inv_aim is '投资目的，无投资目的的存999999';
comment on column ${iol_schema}.fams_ptl_sec_position.hoding_type is '持仓类型，实际、在途、质押、融入、融出';
comment on column ${iol_schema}.fams_ptl_sec_position.cdate is '日期';
comment on column ${iol_schema}.fams_ptl_sec_position.amount is '数量';
comment on column ${iol_schema}.fams_ptl_sec_position.ccy is '币种，资产对应的币种';
comment on column ${iol_schema}.fams_ptl_sec_position.p_finprod_id is '母金融产品代码';
comment on column ${iol_schema}.fams_ptl_sec_position.face_value is '百元面值';
comment on column ${iol_schema}.fams_ptl_sec_position.create_user is '创建人';
comment on column ${iol_schema}.fams_ptl_sec_position.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ptl_sec_position.create_time is '创建时间';
comment on column ${iol_schema}.fams_ptl_sec_position.update_user is '更新人';
comment on column ${iol_schema}.fams_ptl_sec_position.update_time is '更新时间';
comment on column ${iol_schema}.fams_ptl_sec_position.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ptl_sec_position.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ptl_sec_position.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ptl_sec_position.etl_timestamp is 'ETL处理时间戳';
