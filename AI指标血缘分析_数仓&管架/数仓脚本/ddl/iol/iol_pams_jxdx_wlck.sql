/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_wlck
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_wlck
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_wlck purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_wlck(
    jxdxdh number -- 绩效对象代号
    ,wcbh varchar2(60) -- 网存编号
    ,bz varchar2(90) -- 币种
    ,jgdh varchar2(180) -- 机构代号
    ,kmh varchar2(180) -- 科目号
    ,khrq number -- 开户日期
    ,dqrq number -- 到期日期
    ,zhye number(30,2) -- 账户余额
    ,cpbh varchar2(180) -- 产品编号
    ,qxrq number -- 起息日期
    ,qx varchar2(18) -- 期限
    ,djbz varchar2(30) -- 冻结标志
    ,djje number(30,2) -- 冻结金额
    ,dybz varchar2(30) -- 抵质押标志
    ,dyje number(30,2) -- 抵质押金额
    ,nll number(18,6) -- 年利率
    ,dryjlx number(30,2) -- 当日月计利息
    ,tjrq number -- 统计日期
    ,khdxdh number -- 考核对象代号
    ,gxhslx varchar2(6) -- 关系函数类型
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
grant select on ${iol_schema}.pams_jxdx_wlck to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_wlck to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_wlck to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_wlck to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_wlck is '绩效对象_网络存款';
comment on column ${iol_schema}.pams_jxdx_wlck.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_wlck.wcbh is '网存编号';
comment on column ${iol_schema}.pams_jxdx_wlck.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_wlck.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_wlck.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_wlck.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_wlck.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxdx_wlck.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_wlck.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxdx_wlck.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxdx_wlck.qx is '期限';
comment on column ${iol_schema}.pams_jxdx_wlck.djbz is '冻结标志';
comment on column ${iol_schema}.pams_jxdx_wlck.djje is '冻结金额';
comment on column ${iol_schema}.pams_jxdx_wlck.dybz is '抵质押标志';
comment on column ${iol_schema}.pams_jxdx_wlck.dyje is '抵质押金额';
comment on column ${iol_schema}.pams_jxdx_wlck.nll is '年利率';
comment on column ${iol_schema}.pams_jxdx_wlck.dryjlx is '当日月计利息';
comment on column ${iol_schema}.pams_jxdx_wlck.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_wlck.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_wlck.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_wlck.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_wlck.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_wlck.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_wlck.etl_timestamp is 'ETL处理时间戳';
