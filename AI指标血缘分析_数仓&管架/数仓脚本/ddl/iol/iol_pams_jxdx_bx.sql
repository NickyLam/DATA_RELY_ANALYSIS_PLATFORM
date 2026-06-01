/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_bx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_bx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_bx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_bx(
    jxdxdh number(38,0) -- 绩效对象代号
    ,tjrq number(38,0) -- 统计日期
    ,jyzhdh varchar2(300) -- 账号代号
    ,cph varchar2(300) -- 产品号
    ,cpmc varchar2(750) -- 产品名称
    ,bxdbh varchar2(300) -- 保险单编号
    ,xybh varchar2(750) -- 协议编号
    ,frbh varchar2(180) -- 法人编号
    ,tadm varchar2(90) -- TA代码
    ,khh varchar2(300) -- 客户号
    ,jgdh varchar2(300) -- 机构代号
    ,hydh varchar2(300) -- 行员代号
    ,gydh varchar2(300) -- 柜员工号
    ,jyrq number(38,0) -- 交易日期
    ,bdrq number(38,0) -- 保单日期
    ,bdsxrq number(38,0) -- 保单生效日期
    ,bxdqrq number(38,0) -- 保险到期日期
    ,tbrmc varchar2(300) -- 投保人名称
    ,tbrzjhm varchar2(300) -- 投保人证件号码
    ,bxgsmc varchar2(1500) -- 保险公司名称
    ,xzlx varchar2(300) -- 险种类型
    ,zxmc varchar2(300) -- 产品全称
    ,tbxz varchar2(300) -- 投保险种
    ,bbxrmc varchar2(300) -- 被保险人名称
    ,bbxrzjhm varchar2(300) -- 被保险人证件号码
    ,jffs varchar2(90) -- 缴费方式
    ,jfnqdw varchar2(90) -- 缴费年期单位
    ,bxqxdw varchar2(90) -- 保险期限单位
    ,jfnq varchar2(90) -- 缴费年期
    ,bxqx varchar2(90) -- 保险期限
    ,jyqd varchar2(60) -- 交易渠道
    ,bdzt varchar2(90) -- 保单状态
    ,tbrq number(38,0) -- 投保日期
    ,zhye number(30,2) -- 账户余额
    ,dlsxfl number(30,2) -- 代理手续费率
    ,dlsxf number(30,2) -- 代理手续费
    ,khdxdh number(38,0) -- 考核对象代号
    ,gxhslx varchar2(30) -- 关系函数类型
    ,qs varchar2(300) -- 取数
    ,xzmc varchar2(300) -- 险种名称
    ,bf number(30,2) -- 保费
    ,nlj number(30,2) -- 年累计
    ,jlj number(30,2) -- 季累计
    ,ylj number(30,2) -- 月累计余额
    ,nrj number(30,2) -- 年日均
    ,jrj number(30,2) -- 季日均
    ,yrj number(30,2) -- 月日均
    ,ncye number(30,2) -- 年初余额
    ,jcye number(30,2) -- 季初余额
    ,ycye number(30,2) -- 月初余额
    ,dqye number(30,2) -- 当期余额
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
grant select on ${iol_schema}.pams_jxdx_bx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_bx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_bx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_bx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_bx is '保险账户';
comment on column ${iol_schema}.pams_jxdx_bx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_bx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_bx.jyzhdh is '账号代号';
comment on column ${iol_schema}.pams_jxdx_bx.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_bx.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxdx_bx.bxdbh is '保险单编号';
comment on column ${iol_schema}.pams_jxdx_bx.xybh is '协议编号';
comment on column ${iol_schema}.pams_jxdx_bx.frbh is '法人编号';
comment on column ${iol_schema}.pams_jxdx_bx.tadm is 'TA代码';
comment on column ${iol_schema}.pams_jxdx_bx.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_bx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_bx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_bx.gydh is '柜员工号';
comment on column ${iol_schema}.pams_jxdx_bx.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxdx_bx.bdrq is '保单日期';
comment on column ${iol_schema}.pams_jxdx_bx.bdsxrq is '保单生效日期';
comment on column ${iol_schema}.pams_jxdx_bx.bxdqrq is '保险到期日期';
comment on column ${iol_schema}.pams_jxdx_bx.tbrmc is '投保人名称';
comment on column ${iol_schema}.pams_jxdx_bx.tbrzjhm is '投保人证件号码';
comment on column ${iol_schema}.pams_jxdx_bx.bxgsmc is '保险公司名称';
comment on column ${iol_schema}.pams_jxdx_bx.xzlx is '险种类型';
comment on column ${iol_schema}.pams_jxdx_bx.zxmc is '产品全称';
comment on column ${iol_schema}.pams_jxdx_bx.tbxz is '投保险种';
comment on column ${iol_schema}.pams_jxdx_bx.bbxrmc is '被保险人名称';
comment on column ${iol_schema}.pams_jxdx_bx.bbxrzjhm is '被保险人证件号码';
comment on column ${iol_schema}.pams_jxdx_bx.jffs is '缴费方式';
comment on column ${iol_schema}.pams_jxdx_bx.jfnqdw is '缴费年期单位';
comment on column ${iol_schema}.pams_jxdx_bx.bxqxdw is '保险期限单位';
comment on column ${iol_schema}.pams_jxdx_bx.jfnq is '缴费年期';
comment on column ${iol_schema}.pams_jxdx_bx.bxqx is '保险期限';
comment on column ${iol_schema}.pams_jxdx_bx.jyqd is '交易渠道';
comment on column ${iol_schema}.pams_jxdx_bx.bdzt is '保单状态';
comment on column ${iol_schema}.pams_jxdx_bx.tbrq is '投保日期';
comment on column ${iol_schema}.pams_jxdx_bx.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_bx.dlsxfl is '代理手续费率';
comment on column ${iol_schema}.pams_jxdx_bx.dlsxf is '代理手续费';
comment on column ${iol_schema}.pams_jxdx_bx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_bx.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_bx.qs is '取数';
comment on column ${iol_schema}.pams_jxdx_bx.xzmc is '险种名称';
comment on column ${iol_schema}.pams_jxdx_bx.bf is '保费';
comment on column ${iol_schema}.pams_jxdx_bx.nlj is '年累计';
comment on column ${iol_schema}.pams_jxdx_bx.jlj is '季累计';
comment on column ${iol_schema}.pams_jxdx_bx.ylj is '月累计余额';
comment on column ${iol_schema}.pams_jxdx_bx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxdx_bx.jrj is '季日均';
comment on column ${iol_schema}.pams_jxdx_bx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxdx_bx.ncye is '年初余额';
comment on column ${iol_schema}.pams_jxdx_bx.jcye is '季初余额';
comment on column ${iol_schema}.pams_jxdx_bx.ycye is '月初余额';
comment on column ${iol_schema}.pams_jxdx_bx.dqye is '当期余额';
comment on column ${iol_schema}.pams_jxdx_bx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_bx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_bx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_bx.etl_timestamp is 'ETL处理时间戳';
