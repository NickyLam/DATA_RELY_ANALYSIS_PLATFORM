/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_bond_resale_and_redemp_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_bond_resale_and_redemp_detail
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_bond_resale_and_redemp_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_bond_resale_and_redemp_detail(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,bond_id varchar2(60) -- 债券id
    ,bond_short_name varchar2(120) -- 债券简称
    ,clause_type_code varchar2(36) -- 条款类型编码
    ,clause_type varchar2(90) -- 条款类型
    ,fore_occurrence_date date -- 预计发生日期
    ,price number(18,4) -- 价格
    ,notice_ed date -- 告知截止日
    ,is_sure_to_exercise number(1,0) -- 是否确定行权
    ,is_actually_exercised number(1,0) -- 实际是否行权
    ,par_value number(18,4) -- 面值
    ,interest_rate number(18,4) -- 利息
    ,price_spe_ins varchar2(600) -- 价格特殊说明
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_bond_resale_and_redemp_detail to ${iml_schema};
grant select on ${iol_schema}.uxds_bond_resale_and_redemp_detail to ${icl_schema};
grant select on ${iol_schema}.uxds_bond_resale_and_redemp_detail to ${idl_schema};
grant select on ${iol_schema}.uxds_bond_resale_and_redemp_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_bond_resale_and_redemp_detail is '中国债券回售赎回条款明细';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.bond_id is '债券id';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.bond_short_name is '债券简称';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.clause_type_code is '条款类型编码';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.clause_type is '条款类型';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.fore_occurrence_date is '预计发生日期';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.price is '价格';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.notice_ed is '告知截止日';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.is_sure_to_exercise is '是否确定行权';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.is_actually_exercised is '实际是否行权';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.par_value is '面值';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.interest_rate is '利息';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.price_spe_ins is '价格特殊说明';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.start_dt is '开始时间';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.end_dt is '结束时间';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.id_mark is '增删标志';
comment on column ${iol_schema}.uxds_bond_resale_and_redemp_detail.etl_timestamp is 'ETL处理时间戳';
