/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_lczh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_lczh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_lczh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_lczh(
    jxdxdh number(22,0) -- 绩效对象代号
    ,zhdh varchar2(300) -- 账号
    ,zhhm varchar2(750) -- 账户户名
    ,bz varchar2(5) -- 币种
    ,jgdh varchar2(300) -- 机构代号
    ,kmh varchar2(30) -- 科目号
    ,khrq number(22,0) -- 开户日期
    ,xhrq number(22,0) -- 销户日期
    ,cpdm varchar2(30) -- 产品代码
    ,cplb varchar2(3) -- 产品类别
    ,cpmc varchar2(150) -- 产品名称
    ,mjksr number(22,0) -- 募集开始日
    ,mjjsr number(22,0) -- 募集结束日
    ,nll number(15,7) -- 年利率
    ,zhye number(25,4) -- 账户余额
    ,zhbs varchar2(2) -- 账户标识
    ,zhzt varchar2(27) -- 账户状态
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,khh varchar2(45) -- 客户号
    ,hydh varchar2(23) -- 行员代号
    ,tjrq number(22,0) -- 统计日期
    ,qxrq number(22,0) -- 起息日期
    ,zxrq number(22,0) -- 注销日期
    ,yqnhsyl number(25,4) -- 年化收益率
    ,cpyzsj number(22,0) -- 产品运作时间
    ,mrjehz number(25,4) -- 买入金额汇总
    ,cyfe number(25,4) -- 持有份额
    ,mjje number(25,4) -- 募集金额
    ,zjjszh varchar2(300) -- 资金结算账户
    ,xssdm varchar2(45) -- 销售商代码
    ,yhbh varchar2(90) -- 银行编号
    ,zhbh varchar2(90) -- 账户编号
    ,cplbzs varchar2(30) -- 产品类别展示
    ,yqsylms varchar2(4000) -- 预期收益率描述
    ,lcywlx varchar2(30) -- 理财业务类型
    ,nextkfqsrq number(22) -- 下一个开放起始日期
    ,nextkfjsrq1 number(22) -- 下一个开放结束日期
    ,fxjg varchar2(90) -- 发行机构
    ,cpxldm varchar2(30) -- 产品小类代码
    ,xsfl number(18,8) -- 销售费率
    ,cjfl number(18,8) -- 差价费率
    ,jz number(30,8) -- 净值
    ,mbbh varchar2(750) -- 模板编号
    ,ztbz varchar2(3) -- 在途标志：0-否，1-是
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
grant select on ${iol_schema}.pams_jxdx_lczh to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_lczh to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_lczh to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_lczh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_lczh is '绩效对象-理财账户';
comment on column ${iol_schema}.pams_jxdx_lczh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_lczh.zhdh is '账号';
comment on column ${iol_schema}.pams_jxdx_lczh.zhhm is '账户户名';
comment on column ${iol_schema}.pams_jxdx_lczh.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_lczh.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_lczh.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_lczh.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_lczh.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxdx_lczh.cpdm is '产品代码';
comment on column ${iol_schema}.pams_jxdx_lczh.cplb is '产品类别';
comment on column ${iol_schema}.pams_jxdx_lczh.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxdx_lczh.mjksr is '募集开始日';
comment on column ${iol_schema}.pams_jxdx_lczh.mjjsr is '募集结束日';
comment on column ${iol_schema}.pams_jxdx_lczh.nll is '年利率';
comment on column ${iol_schema}.pams_jxdx_lczh.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_lczh.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxdx_lczh.zhzt is '账户状态';
comment on column ${iol_schema}.pams_jxdx_lczh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_lczh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_lczh.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_lczh.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_lczh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_lczh.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxdx_lczh.zxrq is '注销日期';
comment on column ${iol_schema}.pams_jxdx_lczh.yqnhsyl is '年化收益率';
comment on column ${iol_schema}.pams_jxdx_lczh.cpyzsj is '产品运作时间';
comment on column ${iol_schema}.pams_jxdx_lczh.mrjehz is '买入金额汇总';
comment on column ${iol_schema}.pams_jxdx_lczh.cyfe is '持有份额';
comment on column ${iol_schema}.pams_jxdx_lczh.mjje is '募集金额';
comment on column ${iol_schema}.pams_jxdx_lczh.zjjszh is '资金结算账户';
comment on column ${iol_schema}.pams_jxdx_lczh.xssdm is '销售商代码';
comment on column ${iol_schema}.pams_jxdx_lczh.yhbh is '银行编号';
comment on column ${iol_schema}.pams_jxdx_lczh.zhbh is '账户编号';
comment on column ${iol_schema}.pams_jxdx_lczh.cplbzs is '产品类别展示';
comment on column ${iol_schema}.pams_jxdx_lczh.yqsylms is '预期收益率描述';
comment on column ${iol_schema}.pams_jxdx_lczh.lcywlx is '理财业务类型';
comment on column ${iol_schema}.pams_jxdx_lczh.nextkfqsrq is '下一个开放起始日期';
comment on column ${iol_schema}.pams_jxdx_lczh.nextkfjsrq1 is '下一个开放结束日期';
comment on column ${iol_schema}.pams_jxdx_lczh.fxjg is '发行机构';
comment on column ${iol_schema}.pams_jxdx_lczh.cpxldm is '产品小类代码';
comment on column ${iol_schema}.pams_jxdx_lczh.xsfl is '销售费率';
comment on column ${iol_schema}.pams_jxdx_lczh.cjfl is '差价费率';
comment on column ${iol_schema}.pams_jxdx_lczh.jz is '净值';
comment on column ${iol_schema}.pams_jxdx_lczh.mbbh is '模板编号';
comment on column ${iol_schema}.pams_jxdx_lczh.ztbz is '在途标志：0-否，1-是';
comment on column ${iol_schema}.pams_jxdx_lczh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_lczh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_lczh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_lczh.etl_timestamp is 'ETL处理时间戳';
