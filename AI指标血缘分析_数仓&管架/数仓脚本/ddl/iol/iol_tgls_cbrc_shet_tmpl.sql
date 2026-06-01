/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_shet_tmpl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_shet_tmpl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_shet_tmpl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_shet_tmpl(
    subsys number -- 子系统编号
    ,shetcd varchar2(16) -- 报表编码
    ,verson number -- 版本号
    ,htmlna varchar2(256) -- 报表htm模板名称
    ,exclna varchar2(256) -- 报表excel模板名称
    ,cellxy varchar2(32) -- 数据区域
    ,condxy varchar2(150) -- 报表属性区域
    ,tmstyl varchar2(1) -- 模板样式
    ,begndt date -- 启用日期
    ,overdt date -- 停用日期
    ,rpvrsn varchar2(12) -- 银监版本号
    ,tbrule varchar2(64) -- 表项匹配规则
    ,fipath varchar2(256) -- 报表存储路径
    ,stacid number(19) -- 账套
    ,jsdata varchar2(4000) -- 模板json字符串
    ,jsondata varchar2(4000) -- 报表数据json字符串
    ,maxrow varchar2(8) -- 总行
    ,maxcol varchar2(8) -- 总列
    ,jsonstyle varchar2(4000) -- 报表数据样式
    ,mergecells varchar2(4000) -- 报表单元格合并json字符串
    ,colwidths varchar2(4000) -- 列宽
    ,rowheights varchar2(4000) -- 行高
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
grant select on ${iol_schema}.tgls_cbrc_shet_tmpl to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_tmpl to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_tmpl to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_tmpl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_shet_tmpl is '报表模板信息表';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.subsys is '子系统编号';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.shetcd is '报表编码';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.verson is '版本号';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.htmlna is '报表htm模板名称';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.exclna is '报表excel模板名称';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.cellxy is '数据区域';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.condxy is '报表属性区域';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.tmstyl is '模板样式';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.begndt is '启用日期';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.overdt is '停用日期';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.rpvrsn is '银监版本号';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.tbrule is '表项匹配规则';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.fipath is '报表存储路径';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.stacid is '账套';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.jsdata is '模板json字符串';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.jsondata is '报表数据json字符串';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.maxrow is '总行';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.maxcol is '总列';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.jsonstyle is '报表数据样式';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.mergecells is '报表单元格合并json字符串';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.colwidths is '列宽';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.rowheights is '行高';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_cbrc_shet_tmpl.etl_timestamp is 'ETL处理时间戳';
