/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_lxd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_lxd
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_lxd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_lxd(
    jxdxdh number(22,0) -- 绩效对象
    ,ywbh varchar2(375) -- 业务编号
    ,wbzjzhbh varchar2(90) -- 外部证券账户编号
    ,nbzjzhbh varchar2(90) -- 内部证券账户编号
    ,jrgjbh varchar2(90) -- 金融工具编号
    ,zclxbh varchar2(90) -- 资产类型编号
    ,sclxbh varchar2(90) -- 市场类型编号
    ,khh varchar2(45) -- 客户号
    ,khmc varchar2(750) -- 客户名称
    ,jydf varchar2(375) -- 交易对手分类描述
    ,jyr number(22,0) -- 交易日期
    ,dqr number(22,0) -- 到期日期
    ,bz varchar2(45) -- 币种
    ,tzje number(30,8) -- 交易金额
    ,qmye number(30,8) -- 当期余额
    ,ylj number(30,8) -- 月累计余额
    ,nlj number(30,8) -- 年累计余额
    ,yqsyl number(30,8) -- 票面利率
    ,jxfs varchar2(90) -- 记息方式
    ,tzlx varchar2(375) -- 资产类型名称
    ,khjg varchar2(90) -- 开户机构
    ,ssfhhh varchar2(90) -- 所属机构编号
    ,ssfh varchar2(90) -- 所属分行
    ,tjrq number(22,0) -- 统计日期
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
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
grant select on ${iol_schema}.pams_jxdx_lxd to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_lxd to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_lxd to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_lxd to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_lxd is '绩效对象-类信贷';
comment on column ${iol_schema}.pams_jxdx_lxd.jxdxdh is '绩效对象';
comment on column ${iol_schema}.pams_jxdx_lxd.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxdx_lxd.wbzjzhbh is '外部证券账户编号';
comment on column ${iol_schema}.pams_jxdx_lxd.nbzjzhbh is '内部证券账户编号';
comment on column ${iol_schema}.pams_jxdx_lxd.jrgjbh is '金融工具编号';
comment on column ${iol_schema}.pams_jxdx_lxd.zclxbh is '资产类型编号';
comment on column ${iol_schema}.pams_jxdx_lxd.sclxbh is '市场类型编号';
comment on column ${iol_schema}.pams_jxdx_lxd.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_lxd.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxdx_lxd.jydf is '交易对手分类描述';
comment on column ${iol_schema}.pams_jxdx_lxd.jyr is '交易日期';
comment on column ${iol_schema}.pams_jxdx_lxd.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxdx_lxd.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_lxd.tzje is '交易金额';
comment on column ${iol_schema}.pams_jxdx_lxd.qmye is '当期余额';
comment on column ${iol_schema}.pams_jxdx_lxd.ylj is '月累计余额';
comment on column ${iol_schema}.pams_jxdx_lxd.nlj is '年累计余额';
comment on column ${iol_schema}.pams_jxdx_lxd.yqsyl is '票面利率';
comment on column ${iol_schema}.pams_jxdx_lxd.jxfs is '记息方式';
comment on column ${iol_schema}.pams_jxdx_lxd.tzlx is '资产类型名称';
comment on column ${iol_schema}.pams_jxdx_lxd.khjg is '开户机构';
comment on column ${iol_schema}.pams_jxdx_lxd.ssfhhh is '所属机构编号';
comment on column ${iol_schema}.pams_jxdx_lxd.ssfh is '所属分行';
comment on column ${iol_schema}.pams_jxdx_lxd.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_lxd.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_lxd.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_lxd.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_lxd.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_lxd.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_lxd.etl_timestamp is 'ETL处理时间戳';
