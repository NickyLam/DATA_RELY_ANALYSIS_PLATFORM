/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_ckzh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_ckzh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_ckzh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_ckzh(
    jxdxdh number(22,0) -- 绩效对象代号
    ,zhdh varchar2(60) -- 账户代号
    ,zzh varchar2(60) -- 子账户
    ,zhhm varchar2(750) -- 账户户名
    ,bz varchar2(5) -- 币种
    ,cph varchar2(30) -- 产品号
    ,kmh varchar2(30) -- 科目号
    ,pzh varchar2(60) -- 凭证号
    ,jgdh varchar2(15) -- 机构代号
    ,khh varchar2(45) -- 客户号
    ,khrq number(22,0) -- 开户日期
    ,qxrq number(22,0) -- 期限日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zhzt varchar2(3) -- 账户状态
    ,zhsx varchar2(45) -- 账户属性
    ,qx varchar2(15) -- 期限日期
    ,nll number(15,7) -- 年利率
    ,zhye number(25,4) -- 账户余额
    ,zhbs varchar2(2) -- 账户标识
    ,hydh varchar2(18) -- 行员代号
    ,tjrq number(22,0) -- 统计日期
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,czdm varchar2(30) -- 储种代码
    ,dhbz varchar2(15) -- 定活标志
    ,jtlxzc number(25,4) -- 计提利息支出
    ,zzkzqr varchar2(27) -- 最早可支取日
    ,kh varchar2(60) -- 卡号
    ,sfhx varchar2(2) -- 是否核心
    ,khje number(25,4) -- 客户金额
    ,zjhm varchar2(75) -- 证件号码
    ,ywtxdm varchar2(45) -- 
    ,khjg varchar2(90) -- 
    ,khgybh varchar2(150) -- 
    ,chbz varchar2(15) -- 
    ,tyckbz varchar2(15) -- 
    ,shhbz varchar2(15) -- 
    ,djbz varchar2(15) -- 
    ,djje number(30,2) -- 
    ,djdqrq number(22,0) -- 
    ,zdzcbz varchar2(15) -- 
    ,yzccs number(22,0) -- 
    ,xdckbz varchar2(15) -- 
    ,xdll number(18,6) -- 
    ,xdcklcje number(30,2) -- 
    ,bzjbz varchar2(15) -- 
    ,jgxckbz varchar2(15) -- 
    ,jzll varchar2(45) -- 
    ,ktqzqbz varchar2(15) -- 
    ,kzrbz varchar2(15) -- 
    ,dfgzzhbz varchar2(15) -- 
    ,tzckbz varchar2(15) -- 
    ,wlckbz varchar2(15) -- 
    ,txyckbz varchar2(15) -- 
    ,dzybz varchar2(15) -- 
    ,dzyje number(30,2) -- 
    ,glhxckzh varchar2(90) -- 
    ,p2pckbz varchar2(15) -- 
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
grant select on ${iol_schema}.pams_jxdx_ckzh to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_ckzh to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_ckzh to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_ckzh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_ckzh is '绩效对象-存款子账户';
comment on column ${iol_schema}.pams_jxdx_ckzh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_ckzh.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_ckzh.zzh is '子账户';
comment on column ${iol_schema}.pams_jxdx_ckzh.zhhm is '账户户名';
comment on column ${iol_schema}.pams_jxdx_ckzh.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_ckzh.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_ckzh.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_ckzh.pzh is '凭证号';
comment on column ${iol_schema}.pams_jxdx_ckzh.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_ckzh.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_ckzh.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_ckzh.qxrq is '期限日期';
comment on column ${iol_schema}.pams_jxdx_ckzh.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxdx_ckzh.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxdx_ckzh.zhzt is '账户状态';
comment on column ${iol_schema}.pams_jxdx_ckzh.zhsx is '账户属性';
comment on column ${iol_schema}.pams_jxdx_ckzh.qx is '期限日期';
comment on column ${iol_schema}.pams_jxdx_ckzh.nll is '年利率';
comment on column ${iol_schema}.pams_jxdx_ckzh.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_ckzh.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxdx_ckzh.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_ckzh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_ckzh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_ckzh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_ckzh.czdm is '储种代码';
comment on column ${iol_schema}.pams_jxdx_ckzh.dhbz is '定活标志';
comment on column ${iol_schema}.pams_jxdx_ckzh.jtlxzc is '计提利息支出';
comment on column ${iol_schema}.pams_jxdx_ckzh.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxdx_ckzh.kh is '卡号';
comment on column ${iol_schema}.pams_jxdx_ckzh.sfhx is '是否核心';
comment on column ${iol_schema}.pams_jxdx_ckzh.khje is '客户金额';
comment on column ${iol_schema}.pams_jxdx_ckzh.zjhm is '证件号码';
comment on column ${iol_schema}.pams_jxdx_ckzh.ywtxdm is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.khjg is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.khgybh is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.chbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.tyckbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.shhbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.djbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.djje is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.djdqrq is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.zdzcbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.yzccs is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.xdckbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.xdll is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.xdcklcje is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.bzjbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.jgxckbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.jzll is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.ktqzqbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.kzrbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.dfgzzhbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.tzckbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.wlckbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.txyckbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.dzybz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.dzyje is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.glhxckzh is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.p2pckbz is '';
comment on column ${iol_schema}.pams_jxdx_ckzh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_ckzh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_ckzh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_ckzh.etl_timestamp is 'ETL处理时间戳';
