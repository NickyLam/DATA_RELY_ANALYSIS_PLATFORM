/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_khftpcl_bak
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_khftpcl_bak
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_khftpcl_bak purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_khftpcl_bak(
    tjrq number(38,0) -- 日期
    ,khmc varchar2(500) -- 客户名称
    ,khh varchar2(100) -- 客户号
    ,zhbs varchar2(100) -- 账户标识
    ,lx varchar2(100) -- 类型
    ,jgkhdxdh number(38,0) -- 机构考核对象代号
    ,khkhjg varchar2(100) -- 客户开户机构
    ,khssjg varchar2(100) -- 客户所属机构
    ,dyjsrhj number(25,4) -- 当月净收入合计
    ,ljjsrhj number(25,4) -- 累计净收入合计
    ,ckqmye number(25,4) -- 存款期末余额
    ,ckdyrj number(25,4) -- 存款当月日均
    ,ckljrj number(25,4) -- 存款累计日均
    ,dycklxzc number(25,4) -- 当月存款利息支出
    ,dyftpzysr number(25,4) -- 当月FTP转移收入
    ,dyckftpyyjsr number(25,4) -- 当月存款FTP营业净收入
    ,ljcklxzc number(25,4) -- 累计存款利息支出
    ,ljftpzysr number(25,4) -- 累计FTP转移收入
    ,ljckftpyyjsr number(25,4) -- 累计存款FTP营业净收入
    ,dkqmye number(25,4) -- 贷款期末余额
    ,dkdyrj number(25,4) -- 贷款当月日均
    ,dkljrj number(25,4) -- 贷款累计日均
    ,dydklxsr number(25,4) -- 当月贷款利息收入
    ,dydkftpzycb number(25,4) -- 当月贷款FTP转移成本
    ,dydkftpyyjsr number(25,4) -- 当月贷款FTP营业净收入
    ,ljdklxsr number(25,4) -- 累计贷款利息收入
    ,ljdkftpzycb number(25,4) -- 累计贷款FTP转移成本
    ,ljdkftpyyjsr number(25,4) -- 累计贷款FTP营业净收入
    ,zjywsr number(25,4) -- 中间业务收入
    ,lxdqmye number(25,4) -- 类信贷期末余额
    ,lxddyrj number(25,4) -- 类信贷当月日均
    ,lxdljrj number(25,4) -- 类信贷累计日均
    ,lxddylxsr number(25,4) -- 类信贷当月利息收入
    ,lxddyftpzycb number(25,4) -- 类信贷当月FTP转移成本
    ,lxddyftpjsr number(25,4) -- 类信贷当月FTP净收入
    ,lxdljlxsr number(25,4) -- 类信贷累计利息收入
    ,lxdljftpzycb number(25,4) -- 类信贷累计FTP转移成本
    ,lxdljftpjsr number(25,4) -- 类信贷累计FTP净收入
    ,ztxqmye number(25,4) -- 再贴现期末余额
    ,ztxdyrj number(25,4) -- 再贴现当月日均
    ,ztxljrj number(25,4) -- 再贴现累计日均
    ,ztxdylxzc number(25,4) -- 再贴现当月利息支出
    ,ztxdyftpzysr number(25,4) -- 再贴现当月FTP转移收入
    ,ztxdyftpjsr number(25,4) -- 再贴现当月FTP净收入
    ,ztxljlxzc number(25,4) -- 再贴现累计利息支出
    ,ztxljftpzysr number(25,4) -- 再贴现累计FTP转移收入
    ,ztxljftpyyjsr number(25,4) -- 再贴现累计FTP营业净收入
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
grant select on ${iol_schema}.pams_jxbb_khftpcl_bak to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_khftpcl_bak to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_khftpcl_bak to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_khftpcl_bak to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_khftpcl_bak is '客户ftp创利_重算';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.tjrq is '日期';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lx is '类型';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.khkhjg is '客户开户机构';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.khssjg is '客户所属机构';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dyjsrhj is '当月净收入合计';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ljjsrhj is '累计净收入合计';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ckqmye is '存款期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ckdyrj is '存款当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ckljrj is '存款累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dycklxzc is '当月存款利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dyftpzysr is '当月FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dyckftpyyjsr is '当月存款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ljcklxzc is '累计存款利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ljftpzysr is '累计FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ljckftpyyjsr is '累计存款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dkqmye is '贷款期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dkdyrj is '贷款当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dkljrj is '贷款累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dydklxsr is '当月贷款利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dydkftpzycb is '当月贷款FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.dydkftpyyjsr is '当月贷款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ljdklxsr is '累计贷款利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ljdkftpzycb is '累计贷款FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ljdkftpyyjsr is '累计贷款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxdqmye is '类信贷期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxddyrj is '类信贷当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxdljrj is '类信贷累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxddylxsr is '类信贷当月利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxddyftpzycb is '类信贷当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxddyftpjsr is '类信贷当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxdljlxsr is '类信贷累计利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxdljftpzycb is '类信贷累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.lxdljftpjsr is '类信贷累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxqmye is '再贴现期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxdyrj is '再贴现当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxljrj is '再贴现累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxdylxzc is '再贴现当月利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxdyftpzysr is '再贴现当月FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxdyftpjsr is '再贴现当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxljlxzc is '再贴现累计利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxljftpzysr is '再贴现累计FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.ztxljftpyyjsr is '再贴现累计FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_khftpcl_bak.etl_timestamp is 'ETL处理时间戳';
