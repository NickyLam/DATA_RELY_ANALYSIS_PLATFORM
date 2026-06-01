/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_hyyjgx_tyffzck
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck(
    jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,fpjs varchar2(3) -- 分配角色
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,gxhslx varchar2(2) -- 关系函数类型
    ,yz number(25,4) -- 阈值
    ,clbl number(19,5) -- 存量比例
    ,zlbl number(19,5) -- 增量比例
    ,gxly varchar2(3) -- 关系来源
    ,yylsh number(20,0) -- 预约流水号
    ,gxzt varchar2(2) -- 关系状态
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
grant select on ${iol_schema}.pams_dxgx_hyyjgx_tyffzck to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_tyffzck to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_tyffzck to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_tyffzck to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck is '对象关系_同业业绩关系_同业投融资';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.fpjs is '分配角色';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.qsrq is '起始日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.jsrq is '结束日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.yz is '阈值';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.clbl is '存量比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.zlbl is '增量比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.gxly is '关系来源';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.yylsh is '预约流水号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.gxzt is '关系状态';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.start_dt is '开始时间';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.end_dt is '结束时间';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.id_mark is '增删标志';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_tyffzck.etl_timestamp is 'ETL处理时间戳';
