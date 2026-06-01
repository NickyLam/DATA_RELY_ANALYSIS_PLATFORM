/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_cell_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_cell_info
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_cell_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_cell_info(
    subsys number -- 子系统编号
    ,shetcd varchar2(16) -- 报表编码
    ,itemcd varchar2(32) -- 数据项编码
    ,cellid number -- 数据项id
    ,itemna varchar2(256) -- 数据项名称
    ,crcycd varchar2(3) -- 数据项币种
    ,upitem varchar2(32) -- 上级数据项
    ,totltp varchar2(1) -- 汇总类别
    ,totllv number -- 汇总层次
    ,status varchar2(1) -- 数据项状态
    ,plusfg varchar2(1) -- 加减标志
    ,begndt date -- 启用日期
    ,overdt date -- 停用日期
    ,inptfg varchar2(1) -- 0：指标公式1：excel公式2：静态值
    ,fomutp varchar2(1) -- 取值方式
    ,foluma varchar2(4000) -- 取数公式
    ,datatp varchar2(12) -- 值类型num:数字类型char:字符类型date:日期类型
    ,fomuds varchar2(4000) -- 取数公式说明
    ,remark varchar2(1024) -- 备注
    ,unitnm number -- 数据单位
    ,verson number -- 版本号
    ,coluna varchar2(800) -- 数据项对应列名称
    ,rowsna varchar2(800) -- 数据项对应行名称
    ,stacid number(9) -- 账套
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
grant select on ${iol_schema}.tgls_cbrc_cell_info to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_cell_info to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_cell_info to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_cell_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_cell_info is '数据项信息表';
comment on column ${iol_schema}.tgls_cbrc_cell_info.subsys is '子系统编号';
comment on column ${iol_schema}.tgls_cbrc_cell_info.shetcd is '报表编码';
comment on column ${iol_schema}.tgls_cbrc_cell_info.itemcd is '数据项编码';
comment on column ${iol_schema}.tgls_cbrc_cell_info.cellid is '数据项id';
comment on column ${iol_schema}.tgls_cbrc_cell_info.itemna is '数据项名称';
comment on column ${iol_schema}.tgls_cbrc_cell_info.crcycd is '数据项币种';
comment on column ${iol_schema}.tgls_cbrc_cell_info.upitem is '上级数据项';
comment on column ${iol_schema}.tgls_cbrc_cell_info.totltp is '汇总类别';
comment on column ${iol_schema}.tgls_cbrc_cell_info.totllv is '汇总层次';
comment on column ${iol_schema}.tgls_cbrc_cell_info.status is '数据项状态';
comment on column ${iol_schema}.tgls_cbrc_cell_info.plusfg is '加减标志';
comment on column ${iol_schema}.tgls_cbrc_cell_info.begndt is '启用日期';
comment on column ${iol_schema}.tgls_cbrc_cell_info.overdt is '停用日期';
comment on column ${iol_schema}.tgls_cbrc_cell_info.inptfg is '0：指标公式1：excel公式2：静态值';
comment on column ${iol_schema}.tgls_cbrc_cell_info.fomutp is '取值方式';
comment on column ${iol_schema}.tgls_cbrc_cell_info.foluma is '取数公式';
comment on column ${iol_schema}.tgls_cbrc_cell_info.datatp is '值类型num:数字类型char:字符类型date:日期类型';
comment on column ${iol_schema}.tgls_cbrc_cell_info.fomuds is '取数公式说明';
comment on column ${iol_schema}.tgls_cbrc_cell_info.remark is '备注';
comment on column ${iol_schema}.tgls_cbrc_cell_info.unitnm is '数据单位';
comment on column ${iol_schema}.tgls_cbrc_cell_info.verson is '版本号';
comment on column ${iol_schema}.tgls_cbrc_cell_info.coluna is '数据项对应列名称';
comment on column ${iol_schema}.tgls_cbrc_cell_info.rowsna is '数据项对应行名称';
comment on column ${iol_schema}.tgls_cbrc_cell_info.stacid is '账套';
comment on column ${iol_schema}.tgls_cbrc_cell_info.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_cbrc_cell_info.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_cbrc_cell_info.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_cbrc_cell_info.etl_timestamp is 'ETL处理时间戳';
