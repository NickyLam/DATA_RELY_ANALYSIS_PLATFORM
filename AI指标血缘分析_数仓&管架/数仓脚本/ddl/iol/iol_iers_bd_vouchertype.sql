/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bd_vouchertype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bd_vouchertype
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bd_vouchertype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_vouchertype(
    code varchar2(60) -- 凭证类别编码
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dataoriginflag number(38,0) -- 数据来源
    ,description varchar2(450) -- 凭证类别描述
    ,description2 varchar2(450) -- 凭证类别描述2
    ,description3 varchar2(450) -- 凭证类别描述3
    ,description4 varchar2(450) -- 凭证类别描述4
    ,description5 varchar2(450) -- 凭证类别描述5
    ,description6 varchar2(450) -- 凭证类别描述6
    ,dr number(10,0) -- 删除标志
    ,enablestate number(38,0) -- 启用状态
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,name varchar2(450) -- 凭证类别名称
    ,name2 varchar2(450) -- 凭证类别名称2
    ,name3 varchar2(450) -- 凭证类别名称3
    ,name4 varchar2(450) -- 凭证类别名称4
    ,name5 varchar2(450) -- 凭证类别名称5
    ,name6 varchar2(450) -- 凭证类别名称6
    ,pk_currtype varchar2(30) -- 默认币种
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_vouchertype varchar2(30) -- 凭证类别主键
    ,shortname varchar2(450) -- 凭证类别简称
    ,shortname2 varchar2(450) -- 凭证类别简称2
    ,shortname3 varchar2(450) -- 凭证类别简称3
    ,shortname4 varchar2(450) -- 凭证类别简称4
    ,shortname5 varchar2(450) -- 凭证类别简称5
    ,shortname6 varchar2(450) -- 凭证类别简称6
    ,ts varchar2(29) -- 时间戳
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
grant select on ${iol_schema}.iers_bd_vouchertype to ${iml_schema};
grant select on ${iol_schema}.iers_bd_vouchertype to ${icl_schema};
grant select on ${iol_schema}.iers_bd_vouchertype to ${idl_schema};
grant select on ${iol_schema}.iers_bd_vouchertype to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bd_vouchertype is '新费用凭证类别';
comment on column ${iol_schema}.iers_bd_vouchertype.code is '凭证类别编码';
comment on column ${iol_schema}.iers_bd_vouchertype.creationtime is '创建时间';
comment on column ${iol_schema}.iers_bd_vouchertype.creator is '创建人';
comment on column ${iol_schema}.iers_bd_vouchertype.dataoriginflag is '数据来源';
comment on column ${iol_schema}.iers_bd_vouchertype.description is '凭证类别描述';
comment on column ${iol_schema}.iers_bd_vouchertype.description2 is '凭证类别描述2';
comment on column ${iol_schema}.iers_bd_vouchertype.description3 is '凭证类别描述3';
comment on column ${iol_schema}.iers_bd_vouchertype.description4 is '凭证类别描述4';
comment on column ${iol_schema}.iers_bd_vouchertype.description5 is '凭证类别描述5';
comment on column ${iol_schema}.iers_bd_vouchertype.description6 is '凭证类别描述6';
comment on column ${iol_schema}.iers_bd_vouchertype.dr is '删除标志';
comment on column ${iol_schema}.iers_bd_vouchertype.enablestate is '启用状态';
comment on column ${iol_schema}.iers_bd_vouchertype.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_bd_vouchertype.modifier is '最后修改人';
comment on column ${iol_schema}.iers_bd_vouchertype.name is '凭证类别名称';
comment on column ${iol_schema}.iers_bd_vouchertype.name2 is '凭证类别名称2';
comment on column ${iol_schema}.iers_bd_vouchertype.name3 is '凭证类别名称3';
comment on column ${iol_schema}.iers_bd_vouchertype.name4 is '凭证类别名称4';
comment on column ${iol_schema}.iers_bd_vouchertype.name5 is '凭证类别名称5';
comment on column ${iol_schema}.iers_bd_vouchertype.name6 is '凭证类别名称6';
comment on column ${iol_schema}.iers_bd_vouchertype.pk_currtype is '默认币种';
comment on column ${iol_schema}.iers_bd_vouchertype.pk_group is '所属集团';
comment on column ${iol_schema}.iers_bd_vouchertype.pk_org is '所属组织';
comment on column ${iol_schema}.iers_bd_vouchertype.pk_vouchertype is '凭证类别主键';
comment on column ${iol_schema}.iers_bd_vouchertype.shortname is '凭证类别简称';
comment on column ${iol_schema}.iers_bd_vouchertype.shortname2 is '凭证类别简称2';
comment on column ${iol_schema}.iers_bd_vouchertype.shortname3 is '凭证类别简称3';
comment on column ${iol_schema}.iers_bd_vouchertype.shortname4 is '凭证类别简称4';
comment on column ${iol_schema}.iers_bd_vouchertype.shortname5 is '凭证类别简称5';
comment on column ${iol_schema}.iers_bd_vouchertype.shortname6 is '凭证类别简称6';
comment on column ${iol_schema}.iers_bd_vouchertype.ts is '时间戳';
comment on column ${iol_schema}.iers_bd_vouchertype.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bd_vouchertype.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bd_vouchertype.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bd_vouchertype.etl_timestamp is 'ETL处理时间戳';
