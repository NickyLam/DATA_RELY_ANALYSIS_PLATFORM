/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_wlckftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_wlckftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_wlckftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_wlckftpmx(
    tjrq number(22,0) -- 统计日期
    ,zhhm varchar2(750) -- 账户户名
    ,zhdh varchar2(75) -- 账号代号
    ,zzh varchar2(75) -- 子账号
    ,kh varchar2(150) -- 卡号
    ,khh varchar2(150) -- 客户号
    ,khjgdh varchar2(75) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,kmh varchar2(75) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,qxmc varchar2(150) -- 期限名称
    ,cph varchar2(75) -- 产品号
    ,cpejfl varchar2(75) -- 产品二级分类
    ,cpsjfl varchar2(75) -- 产品三级分类
    ,cpsijfl varchar2(75) -- 产品四级分类
    ,cpmc varchar2(150) -- 产品中文名称
    ,zxll number(15,7) -- 账户执行利率
    ,sjll number(15,7) -- 新型存款实际利率
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zzkzqr varchar2(30) -- 最早可支取日
    ,sfzy varchar2(15) -- 是否质押
    ,sfhx varchar2(300) -- 是否核心存款
    ,bz varchar2(45) -- 币种
    ,ye number(25,4) -- 余额
    ,dyrj number(25,4) -- 当月日均
    ,ljrj number(25,4) -- 累计日均
    ,dylxzc number(25,4) -- 当月利息支出
    ,ljlxzc number(25,4) -- 累计利息支出
    ,ftpjg number(25,4) -- ftp价格
    ,dyftpzysr number(25,4) -- 当月ftp转移收入
    ,ljftpzysr number(25,4) -- 累计ftp转移收入
    ,dyftpjsy number(25,4) -- 当月ftp净收益
    ,ljftpjsy number(25,4) -- 累计ftp净收益
    ,zjywsr number(25,4) -- 中间业务收入
    ,bzdm varchar2(15) -- 币种码值
    ,khjldh varchar2(75) -- 客户经理工号
    ,ssjgdh varchar2(75) -- 所属机构号
    ,fpbl number(15,4) -- 分配比例
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
grant select on ${iol_schema}.pams_jxbb_wlckftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_wlckftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_wlckftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_wlckftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_wlckftpmx is '网络存款';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.zhhm is '账户户名';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.zhdh is '账号代号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.kh is '卡号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.qxmc is '期限名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.cph is '产品号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.cpsjfl is '产品三级分类';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.cpmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.zxll is '账户执行利率';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.sjll is '新型存款实际利率';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.sfhx is '是否核心存款';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.dyrj is '当月日均';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.ljrj is '累计日均';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.dylxzc is '当月利息支出';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.ljlxzc is '累计利息支出';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.ftpjg is 'ftp价格';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.dyftpzysr is '当月ftp转移收入';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.ljftpzysr is '累计ftp转移收入';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.dyftpjsy is '当月ftp净收益';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.ljftpjsy is '累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.khjldh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx.etl_timestamp is 'ETL处理时间戳';
