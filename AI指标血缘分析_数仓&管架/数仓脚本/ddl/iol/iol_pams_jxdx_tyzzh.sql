/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_tyzzh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_tyzzh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_tyzzh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_tyzzh(
    jxdxdh number(22,0) -- 绩效对象代号
    ,zhdh varchar2(60) -- 账户代号
    ,zzh varchar2(60) -- 子账号
    ,zhhm varchar2(750) -- 账户名称
    ,bz varchar2(5) -- 币种
    ,cph varchar2(30) -- 产品号
    ,kmh varchar2(30) -- 科目号
    ,pzh varchar2(60) -- 凭证号
    ,jgdh varchar2(15) -- 机构代号
    ,khh varchar2(45) -- 客户号
    ,khrq number(22,0) -- 开户日期
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zhzt varchar2(3) -- 账户状态
    ,zhsx varchar2(45) -- 账户属性
    ,qx varchar2(15) -- 期限
    ,nll number(15,7) -- 年利率
    ,zhye number(25,4) -- 账户余额
    ,zhbs varchar2(2) -- 账户标识
    ,hydh varchar2(18) -- 行员代号
    ,tjrq number(22,0) -- 统计日期
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,czdm varchar2(30) -- 操作代码
    ,dhbz varchar2(15) -- 定活标志
    ,jtlxzc number(25,4) -- 计提利息支出
    ,zzkzqr varchar2(27) -- 最早可支取日
    ,kh varchar2(60) -- 卡号
    ,sfhx varchar2(2) -- 是否核心
    ,khje number(25,4) -- 开户金额
    ,zjhm varchar2(75) -- 证件号码
    ,ywtxdm varchar2(45) -- 业务贴现代码
    ,khjg varchar2(90) -- 开户机构
    ,khgybh varchar2(150) -- 开户柜员编号
    ,chbz varchar2(15) -- 钞汇标志
    ,tyckbz varchar2(15) -- 同业存款标志
    ,shhbz varchar2(15) -- 睡眠户标志
    ,djbz varchar2(15) -- 冻结标志
    ,djje number(30,2) -- 冻结金额
    ,djdqrq number(22,0) -- 冻结到期日期
    ,zdzcbz varchar2(15) -- 自动转存标志
    ,yzccs number(22,0) -- 已转存次数
    ,xdckbz varchar2(15) -- 协定存款标志
    ,xdll number(18,6) -- 协定利率
    ,xdcklcje number(30,2) -- 协定存款留存金额
    ,bzjbz varchar2(15) -- 币种j币种
    ,jgxckbz varchar2(15) -- 结构性存款标志
    ,jzll varchar2(45) -- 基准利率
    ,ktqzqbz varchar2(15) -- 可提前支取标志
    ,kzrbz varchar2(15) -- 可转让标志
    ,dfgzzhbz varchar2(15) -- 代发工资账户标志
    ,tzckbz varchar2(15) -- 通知存款标志
    ,wlckbz varchar2(15) -- 网络存款标志
    ,txyckbz varchar2(15) -- 同兴赢存款标志
    ,dzybz varchar2(15) -- 抵质押标志
    ,dzyje number(30,2) -- 抵质押金额
    ,glhxckzh varchar2(90) -- 关联核心存款账户
    ,p2pckbz varchar2(15) -- 是否p2p标识
    ,khqd varchar2(15) -- 开户渠道类型代码
    ,yhzhzl varchar2(15) -- 用户账号种类
    ,zhbh varchar2(150) -- 账户编号
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
grant select on ${iol_schema}.pams_jxdx_tyzzh to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_tyzzh to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_tyzzh to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_tyzzh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_tyzzh is '绩效对象_同业投融资表';
comment on column ${iol_schema}.pams_jxdx_tyzzh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zzh is '子账号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zhhm is '账户名称';
comment on column ${iol_schema}.pams_jxdx_tyzzh.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_tyzzh.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.pzh is '凭证号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_tyzzh.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxdx_tyzzh.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxdx_tyzzh.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zhzt is '账户状态';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zhsx is '账户属性';
comment on column ${iol_schema}.pams_jxdx_tyzzh.qx is '期限';
comment on column ${iol_schema}.pams_jxdx_tyzzh.nll is '年利率';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxdx_tyzzh.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_tyzzh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_tyzzh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.czdm is '操作代码';
comment on column ${iol_schema}.pams_jxdx_tyzzh.dhbz is '定活标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.jtlxzc is '计提利息支出';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxdx_tyzzh.kh is '卡号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.sfhx is '是否核心';
comment on column ${iol_schema}.pams_jxdx_tyzzh.khje is '开户金额';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zjhm is '证件号码';
comment on column ${iol_schema}.pams_jxdx_tyzzh.ywtxdm is '业务贴现代码';
comment on column ${iol_schema}.pams_jxdx_tyzzh.khjg is '开户机构';
comment on column ${iol_schema}.pams_jxdx_tyzzh.khgybh is '开户柜员编号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.chbz is '钞汇标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.tyckbz is '同业存款标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.shhbz is '睡眠户标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.djbz is '冻结标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.djje is '冻结金额';
comment on column ${iol_schema}.pams_jxdx_tyzzh.djdqrq is '冻结到期日期';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zdzcbz is '自动转存标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.yzccs is '已转存次数';
comment on column ${iol_schema}.pams_jxdx_tyzzh.xdckbz is '协定存款标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.xdll is '协定利率';
comment on column ${iol_schema}.pams_jxdx_tyzzh.xdcklcje is '协定存款留存金额';
comment on column ${iol_schema}.pams_jxdx_tyzzh.bzjbz is '币种j币种';
comment on column ${iol_schema}.pams_jxdx_tyzzh.jgxckbz is '结构性存款标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxdx_tyzzh.ktqzqbz is '可提前支取标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.kzrbz is '可转让标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.dfgzzhbz is '代发工资账户标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.tzckbz is '通知存款标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.wlckbz is '网络存款标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.txyckbz is '同兴赢存款标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.dzybz is '抵质押标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.dzyje is '抵质押金额';
comment on column ${iol_schema}.pams_jxdx_tyzzh.glhxckzh is '关联核心存款账户';
comment on column ${iol_schema}.pams_jxdx_tyzzh.p2pckbz is '是否p2p标识';
comment on column ${iol_schema}.pams_jxdx_tyzzh.khqd is '开户渠道类型代码';
comment on column ${iol_schema}.pams_jxdx_tyzzh.yhzhzl is '用户账号种类';
comment on column ${iol_schema}.pams_jxdx_tyzzh.zhbh is '账户编号';
comment on column ${iol_schema}.pams_jxdx_tyzzh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_tyzzh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_tyzzh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_tyzzh.etl_timestamp is 'ETL处理时间戳';
