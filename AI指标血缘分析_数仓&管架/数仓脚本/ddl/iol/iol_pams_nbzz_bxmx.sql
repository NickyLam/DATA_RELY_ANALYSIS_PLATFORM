/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_bxmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_bxmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_bxmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_bxmx(
    tjrq number(38,0) -- 统计日期
    ,jxdxdh number(38,0) -- 绩效对象代号
    ,khh varchar2(300) -- 客户号
    ,jgdh varchar2(300) -- 机构代号
    ,khdxdh number(38,0) -- 考核对象代号
    ,jgkhdxdh number(38,0) -- 机构考核对象代号
    ,bz varchar2(9) -- 币种
    ,fpjs varchar2(6) -- 分配角色
    ,zlbl number(19,5) -- 增量比例
    ,bf number(25,4) -- 保费
    ,zs number(25,4) -- 中收
    ,jyzhdh varchar2(300) -- 账号代号
    ,cph varchar2(300) -- 产品号
    ,bxdbh varchar2(300) -- 保险单编号
    ,xybh varchar2(750) -- 签约协议编号
    ,frbh varchar2(180) -- 法人编号
    ,tadm varchar2(90) -- TA代码
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
    ,zxmc varchar2(300) -- 险种名称
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
    ,qs varchar2(300) -- 取数
    ,fphzhye number(30,2) -- 分配后余额
    ,fphsxf number(30,2) -- 分配后手续费
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
    ,sxfnlj number(25,4) -- 手续费年累计
    ,sxfjlj number(25,4) -- 手续费季累计
    ,sxfylj number(25,4) -- 手续费月累计
    ,bxgmbf number(25,4) -- 规模保费
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_nbzz_bxmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_bxmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_bxmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_bxmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_bxmx is '保险明细账';
comment on column ${iol_schema}.pams_nbzz_bxmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_bxmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_bxmx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_bxmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_bxmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_bxmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_bxmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_bxmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_bxmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_bxmx.bf is '保费';
comment on column ${iol_schema}.pams_nbzz_bxmx.zs is '中收';
comment on column ${iol_schema}.pams_nbzz_bxmx.jyzhdh is '账号代号';
comment on column ${iol_schema}.pams_nbzz_bxmx.cph is '产品号';
comment on column ${iol_schema}.pams_nbzz_bxmx.bxdbh is '保险单编号';
comment on column ${iol_schema}.pams_nbzz_bxmx.xybh is '签约协议编号';
comment on column ${iol_schema}.pams_nbzz_bxmx.frbh is '法人编号';
comment on column ${iol_schema}.pams_nbzz_bxmx.tadm is 'TA代码';
comment on column ${iol_schema}.pams_nbzz_bxmx.hydh is '行员代号';
comment on column ${iol_schema}.pams_nbzz_bxmx.gydh is '柜员工号';
comment on column ${iol_schema}.pams_nbzz_bxmx.jyrq is '交易日期';
comment on column ${iol_schema}.pams_nbzz_bxmx.bdrq is '保单日期';
comment on column ${iol_schema}.pams_nbzz_bxmx.bdsxrq is '保单生效日期';
comment on column ${iol_schema}.pams_nbzz_bxmx.bxdqrq is '保险到期日期';
comment on column ${iol_schema}.pams_nbzz_bxmx.tbrmc is '投保人名称';
comment on column ${iol_schema}.pams_nbzz_bxmx.tbrzjhm is '投保人证件号码';
comment on column ${iol_schema}.pams_nbzz_bxmx.bxgsmc is '保险公司名称';
comment on column ${iol_schema}.pams_nbzz_bxmx.xzlx is '险种类型';
comment on column ${iol_schema}.pams_nbzz_bxmx.zxmc is '险种名称';
comment on column ${iol_schema}.pams_nbzz_bxmx.tbxz is '投保险种';
comment on column ${iol_schema}.pams_nbzz_bxmx.bbxrmc is '被保险人名称';
comment on column ${iol_schema}.pams_nbzz_bxmx.bbxrzjhm is '被保险人证件号码';
comment on column ${iol_schema}.pams_nbzz_bxmx.jffs is '缴费方式';
comment on column ${iol_schema}.pams_nbzz_bxmx.jfnqdw is '缴费年期单位';
comment on column ${iol_schema}.pams_nbzz_bxmx.bxqxdw is '保险期限单位';
comment on column ${iol_schema}.pams_nbzz_bxmx.jfnq is '缴费年期';
comment on column ${iol_schema}.pams_nbzz_bxmx.bxqx is '保险期限';
comment on column ${iol_schema}.pams_nbzz_bxmx.jyqd is '交易渠道';
comment on column ${iol_schema}.pams_nbzz_bxmx.bdzt is '保单状态';
comment on column ${iol_schema}.pams_nbzz_bxmx.tbrq is '投保日期';
comment on column ${iol_schema}.pams_nbzz_bxmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_bxmx.dlsxfl is '代理手续费率';
comment on column ${iol_schema}.pams_nbzz_bxmx.dlsxf is '代理手续费';
comment on column ${iol_schema}.pams_nbzz_bxmx.qs is '取数';
comment on column ${iol_schema}.pams_nbzz_bxmx.fphzhye is '分配后余额';
comment on column ${iol_schema}.pams_nbzz_bxmx.fphsxf is '分配后手续费';
comment on column ${iol_schema}.pams_nbzz_bxmx.nlj is '年累计';
comment on column ${iol_schema}.pams_nbzz_bxmx.jlj is '季累计';
comment on column ${iol_schema}.pams_nbzz_bxmx.ylj is '月累计余额';
comment on column ${iol_schema}.pams_nbzz_bxmx.nrj is '年日均';
comment on column ${iol_schema}.pams_nbzz_bxmx.jrj is '季日均';
comment on column ${iol_schema}.pams_nbzz_bxmx.yrj is '月日均';
comment on column ${iol_schema}.pams_nbzz_bxmx.ncye is '年初余额';
comment on column ${iol_schema}.pams_nbzz_bxmx.jcye is '季初余额';
comment on column ${iol_schema}.pams_nbzz_bxmx.ycye is '月初余额';
comment on column ${iol_schema}.pams_nbzz_bxmx.dqye is '当期余额';
comment on column ${iol_schema}.pams_nbzz_bxmx.sxfnlj is '手续费年累计';
comment on column ${iol_schema}.pams_nbzz_bxmx.sxfjlj is '手续费季累计';
comment on column ${iol_schema}.pams_nbzz_bxmx.sxfylj is '手续费月累计';
comment on column ${iol_schema}.pams_nbzz_bxmx.bxgmbf is '规模保费';
comment on column ${iol_schema}.pams_nbzz_bxmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_bxmx.etl_timestamp is 'ETL处理时间戳';
