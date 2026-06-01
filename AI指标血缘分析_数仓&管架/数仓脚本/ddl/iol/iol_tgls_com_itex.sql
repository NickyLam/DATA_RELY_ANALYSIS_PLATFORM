/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_itex
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_itex
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_itex purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_itex(
    stacid number(19) -- 账套标记
    ,assimp varchar2(10) -- 对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）
    ,acexcd varchar2(6) -- 辅助核算项代码
    ,acexna varchar2(20) -- 辅助核算项名称
    ,valide varchar2(1) -- 有效状态位
    ,fromdt varchar2(8) -- 启用日期
    ,pscope varchar2(1) -- 级别
    ,ordeid number(3) -- 序号
    ,desctx varchar2(20) -- 变量说明
    ,userst varchar2(1) -- 使用状态（0未使用，1已使用）
    ,defavl varchar2(64) -- 默认值
    ,istkcl varchar2(1) -- 是否参与核算0不参与1参与
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
grant select on ${iol_schema}.tgls_com_itex to ${iml_schema};
grant select on ${iol_schema}.tgls_com_itex to ${icl_schema};
grant select on ${iol_schema}.tgls_com_itex to ${idl_schema};
grant select on ${iol_schema}.tgls_com_itex to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_itex is '会计科目自定义辅助核算项扩展表';
comment on column ${iol_schema}.tgls_com_itex.stacid is '账套标记';
comment on column ${iol_schema}.tgls_com_itex.assimp is '对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）';
comment on column ${iol_schema}.tgls_com_itex.acexcd is '辅助核算项代码';
comment on column ${iol_schema}.tgls_com_itex.acexna is '辅助核算项名称';
comment on column ${iol_schema}.tgls_com_itex.valide is '有效状态位';
comment on column ${iol_schema}.tgls_com_itex.fromdt is '启用日期';
comment on column ${iol_schema}.tgls_com_itex.pscope is '级别';
comment on column ${iol_schema}.tgls_com_itex.ordeid is '序号';
comment on column ${iol_schema}.tgls_com_itex.desctx is '变量说明';
comment on column ${iol_schema}.tgls_com_itex.userst is '使用状态（0未使用，1已使用）';
comment on column ${iol_schema}.tgls_com_itex.defavl is '默认值';
comment on column ${iol_schema}.tgls_com_itex.istkcl is '是否参与核算0不参与1参与';
comment on column ${iol_schema}.tgls_com_itex.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_itex.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_itex.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_itex.etl_timestamp is 'ETL处理时间戳';
