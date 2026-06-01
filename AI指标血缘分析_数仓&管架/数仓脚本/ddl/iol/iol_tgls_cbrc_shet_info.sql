/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_shet_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_shet_info
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_shet_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_shet_info(
    subsys number -- 子系统编号
    ,shetcd varchar2(16) -- 报表编码
    ,shetna varchar2(256) -- 报表名称
    ,reptfq varchar2(20) -- 报表统计频度
    ,reptut varchar2(1) -- 报表单位
    ,reptfg varchar2(1) -- 上报标志
    ,begndt date -- 启用日期
    ,overdt date -- 停用日期
    ,shetmp varchar2(1) -- 报表大类
    ,shetsp varchar2(2) -- 报表子类
    ,procna varchar2(512) -- 报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
    ,inptfg varchar2(1) -- 报表生成方式
    ,tabtor varchar2(50) -- 报表创建人
    ,revwer varchar2(50) -- 报表评审人
    ,resper varchar2(50) -- 报表负责人
    ,remark varchar2(256) -- 备注
    ,rpftch varchar2(128) -- 报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)
    ,scheid number -- 编排顺序号
    ,ftitle varchar2(512) -- 报文标题
    ,stitle varchar2(512) -- 报文子标题_x0013_
    ,crcycd varchar2(128) -- 币种(冗余字段，无意义)
    ,shetsn varchar2(128) -- 报文英文名称
    ,curent varchar2(1) -- 是否实时报表
    ,stacid number(9) -- 帐套id
    ,isbala varchar2(1) -- 是否涉及手工调账（1是2否）
    ,isused varchar2(1) -- 启用（1是2否）
    ,shettp varchar2(1) -- 报表类型（1固定报表2动态报表）
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
grant select on ${iol_schema}.tgls_cbrc_shet_info to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_info to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_info to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_shet_info is '报表基本信息表';
comment on column ${iol_schema}.tgls_cbrc_shet_info.subsys is '子系统编号';
comment on column ${iol_schema}.tgls_cbrc_shet_info.shetcd is '报表编码';
comment on column ${iol_schema}.tgls_cbrc_shet_info.shetna is '报表名称';
comment on column ${iol_schema}.tgls_cbrc_shet_info.reptfq is '报表统计频度';
comment on column ${iol_schema}.tgls_cbrc_shet_info.reptut is '报表单位';
comment on column ${iol_schema}.tgls_cbrc_shet_info.reptfg is '上报标志';
comment on column ${iol_schema}.tgls_cbrc_shet_info.begndt is '启用日期';
comment on column ${iol_schema}.tgls_cbrc_shet_info.overdt is '停用日期';
comment on column ${iol_schema}.tgls_cbrc_shet_info.shetmp is '报表大类';
comment on column ${iol_schema}.tgls_cbrc_shet_info.shetsp is '报表子类';
comment on column ${iol_schema}.tgls_cbrc_shet_info.procna is '报表数据集(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)';
comment on column ${iol_schema}.tgls_cbrc_shet_info.inptfg is '报表生成方式';
comment on column ${iol_schema}.tgls_cbrc_shet_info.tabtor is '报表创建人';
comment on column ${iol_schema}.tgls_cbrc_shet_info.revwer is '报表评审人';
comment on column ${iol_schema}.tgls_cbrc_shet_info.resper is '报表负责人';
comment on column ${iol_schema}.tgls_cbrc_shet_info.remark is '备注';
comment on column ${iol_schema}.tgls_cbrc_shet_info.rpftch is '报送口径(冗余字段，统一设置参数，已迁移到cbrc_shet_brch表)';
comment on column ${iol_schema}.tgls_cbrc_shet_info.scheid is '编排顺序号';
comment on column ${iol_schema}.tgls_cbrc_shet_info.ftitle is '报文标题';
comment on column ${iol_schema}.tgls_cbrc_shet_info.stitle is '报文子标题_x0013_';
comment on column ${iol_schema}.tgls_cbrc_shet_info.crcycd is '币种(冗余字段，无意义)';
comment on column ${iol_schema}.tgls_cbrc_shet_info.shetsn is '报文英文名称';
comment on column ${iol_schema}.tgls_cbrc_shet_info.curent is '是否实时报表';
comment on column ${iol_schema}.tgls_cbrc_shet_info.stacid is '帐套id';
comment on column ${iol_schema}.tgls_cbrc_shet_info.isbala is '是否涉及手工调账（1是2否）';
comment on column ${iol_schema}.tgls_cbrc_shet_info.isused is '启用（1是2否）';
comment on column ${iol_schema}.tgls_cbrc_shet_info.shettp is '报表类型（1固定报表2动态报表）';
comment on column ${iol_schema}.tgls_cbrc_shet_info.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_cbrc_shet_info.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_cbrc_shet_info.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_cbrc_shet_info.etl_timestamp is 'ETL处理时间戳';
