/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_dkzh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_dkzh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_dkzh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_dkzh(
    jxdxdh number(22,0) -- 绩效对象代号
    ,zhdh varchar2(60) -- 账户代号
    ,zzh varchar2(150) -- 子账户
    ,zhhm varchar2(750) -- 账户户名
    ,bz varchar2(5) -- 币种
    ,cph varchar2(30) -- 产品号
    ,kmh varchar2(30) -- 科目号
    ,yqkm varchar2(30) -- 逾期科目
    ,jgdh varchar2(15) -- 机构代号
    ,khh varchar2(45) -- 客户号
    ,khrq number(22,0) -- 开户日期
    ,ffrq number(22,0) -- 发放日期
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zhzt varchar2(3) -- 账户状态
    ,qx varchar2(8) -- 期限
    ,nll number(18,8) -- 年利率
    ,llyhbz varchar2(2) -- 利率浮动标志
    ,llyhbl number(18,6) -- 利率浮动比例
    ,pjh varchar2(60) -- 票据号
    ,hth varchar2(75) -- 合同号
    ,dkfs varchar2(3) -- 贷款方式
    ,dkje number(25,4) -- 贷款金额
    ,zhye number(25,4) -- 账户余额
    ,zcye number(25,4) -- 正常余额
    ,yqye number(25,4) -- 逾期余额
    ,daizhiye number(25,4) -- 呆滞余额
    ,daizhangye number(25,4) -- 呆账余额
    ,bzjbl number(18,2) -- 保证金比例
    ,hydh varchar2(18) -- 行员代号
    ,zhbs varchar2(2) -- 账户标识
    ,tjrq number(22,0) -- 统计日期
    ,qygm varchar2(3) -- 企业规模
    ,psckzh varchar2(60) -- 派生存款账户
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,xwdkbs varchar2(2) -- 小微贷款标识
    ,ywpz varchar2(30) -- 业务品种
    ,dkfflb varchar2(45) -- 贷款发放类别
    ,hkfs varchar2(6) -- 还款方式
    ,bjyqts number(22,0) -- 本金逾期天数
    ,lxyqts number(22,0) -- 利息逾期天数
    ,jxfs varchar2(3) -- 计息方式
    ,qynll number(15,7) -- 逾期年利率
    ,sxed number(25,4) -- 授信额度
    ,lsdkbs varchar2(3) -- 绿色贷款标识
    ,jjh varchar2(150) -- 借据号
    ,jjzt varchar2(8) -- 拮据状态
    ,zxll number(25,4) -- 执行利率
    ,jzll number(25,4) -- 基准利率
    ,llfdfs varchar2(8) -- 利率浮动方式
    ,jtlxsr number(25,4) -- 计提利息收入
    ,zyqrq number(22,0) -- 
    ,hxbz varchar2(2) -- 
    ,sndkbz varchar2(15) -- 
    ,lhdkbz varchar2(15) -- 
    ,wldkbz varchar2(15) -- 
    ,se number(38,8) -- 
    ,drlxsr number(38,8) -- 
    ,bwbs varchar2(2) -- 表外标识
    ,zqjh varchar2(60) -- 子区间号
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
grant select on ${iol_schema}.pams_jxdx_dkzh to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_dkzh to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzh to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_dkzh is '绩效对象-贷款账户';
comment on column ${iol_schema}.pams_jxdx_dkzh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_dkzh.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_dkzh.zzh is '子账户';
comment on column ${iol_schema}.pams_jxdx_dkzh.zhhm is '账户户名';
comment on column ${iol_schema}.pams_jxdx_dkzh.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_dkzh.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_dkzh.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_dkzh.yqkm is '逾期科目';
comment on column ${iol_schema}.pams_jxdx_dkzh.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_dkzh.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_dkzh.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_dkzh.ffrq is '发放日期';
comment on column ${iol_schema}.pams_jxdx_dkzh.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxdx_dkzh.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxdx_dkzh.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxdx_dkzh.zhzt is '账户状态';
comment on column ${iol_schema}.pams_jxdx_dkzh.qx is '期限';
comment on column ${iol_schema}.pams_jxdx_dkzh.nll is '年利率';
comment on column ${iol_schema}.pams_jxdx_dkzh.llyhbz is '利率浮动标志';
comment on column ${iol_schema}.pams_jxdx_dkzh.llyhbl is '利率浮动比例';
comment on column ${iol_schema}.pams_jxdx_dkzh.pjh is '票据号';
comment on column ${iol_schema}.pams_jxdx_dkzh.hth is '合同号';
comment on column ${iol_schema}.pams_jxdx_dkzh.dkfs is '贷款方式';
comment on column ${iol_schema}.pams_jxdx_dkzh.dkje is '贷款金额';
comment on column ${iol_schema}.pams_jxdx_dkzh.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_dkzh.zcye is '正常余额';
comment on column ${iol_schema}.pams_jxdx_dkzh.yqye is '逾期余额';
comment on column ${iol_schema}.pams_jxdx_dkzh.daizhiye is '呆滞余额';
comment on column ${iol_schema}.pams_jxdx_dkzh.daizhangye is '呆账余额';
comment on column ${iol_schema}.pams_jxdx_dkzh.bzjbl is '保证金比例';
comment on column ${iol_schema}.pams_jxdx_dkzh.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_dkzh.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxdx_dkzh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_dkzh.qygm is '企业规模';
comment on column ${iol_schema}.pams_jxdx_dkzh.psckzh is '派生存款账户';
comment on column ${iol_schema}.pams_jxdx_dkzh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_dkzh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_dkzh.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxdx_dkzh.ywpz is '业务品种';
comment on column ${iol_schema}.pams_jxdx_dkzh.dkfflb is '贷款发放类别';
comment on column ${iol_schema}.pams_jxdx_dkzh.hkfs is '还款方式';
comment on column ${iol_schema}.pams_jxdx_dkzh.bjyqts is '本金逾期天数';
comment on column ${iol_schema}.pams_jxdx_dkzh.lxyqts is '利息逾期天数';
comment on column ${iol_schema}.pams_jxdx_dkzh.jxfs is '计息方式';
comment on column ${iol_schema}.pams_jxdx_dkzh.qynll is '逾期年利率';
comment on column ${iol_schema}.pams_jxdx_dkzh.sxed is '授信额度';
comment on column ${iol_schema}.pams_jxdx_dkzh.lsdkbs is '绿色贷款标识';
comment on column ${iol_schema}.pams_jxdx_dkzh.jjh is '借据号';
comment on column ${iol_schema}.pams_jxdx_dkzh.jjzt is '拮据状态';
comment on column ${iol_schema}.pams_jxdx_dkzh.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxdx_dkzh.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxdx_dkzh.llfdfs is '利率浮动方式';
comment on column ${iol_schema}.pams_jxdx_dkzh.jtlxsr is '计提利息收入';
comment on column ${iol_schema}.pams_jxdx_dkzh.zyqrq is '';
comment on column ${iol_schema}.pams_jxdx_dkzh.hxbz is '';
comment on column ${iol_schema}.pams_jxdx_dkzh.sndkbz is '';
comment on column ${iol_schema}.pams_jxdx_dkzh.lhdkbz is '';
comment on column ${iol_schema}.pams_jxdx_dkzh.wldkbz is '';
comment on column ${iol_schema}.pams_jxdx_dkzh.se is '';
comment on column ${iol_schema}.pams_jxdx_dkzh.drlxsr is '';
comment on column ${iol_schema}.pams_jxdx_dkzh.bwbs is '表外标识';
comment on column ${iol_schema}.pams_jxdx_dkzh.zqjh is '子区间号';
comment on column ${iol_schema}.pams_jxdx_dkzh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_dkzh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_dkzh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_dkzh.etl_timestamp is 'ETL处理时间戳';
