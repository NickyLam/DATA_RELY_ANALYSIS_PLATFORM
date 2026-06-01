/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_khftpcl_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_khftpcl_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_khftpcl_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_khftpcl_recal(
    tjrq number(22) -- 统计日期
    ,khmc varchar2(1500) -- 客户名称
    ,khh varchar2(300) -- 客户号
    ,zhbs varchar2(300) -- 账户标识
    ,lx varchar2(300) -- 类型
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,khkhjg varchar2(300) -- 客户开户机构
    ,khssjg varchar2(300) -- 客户所属机构
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
    ,ssjgkhdxdh number(22) -- 所属机构考核对象代号
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_khftpcl_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_khftpcl_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_khftpcl_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_khftpcl_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_khftpcl_recal is '客户ftp创利_重算';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lx is '类型';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.khkhjg is '客户开户机构';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.khssjg is '客户所属机构';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dyjsrhj is '当月净收入合计';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ljjsrhj is '累计净收入合计';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ckqmye is '存款期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ckdyrj is '存款当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ckljrj is '存款累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dycklxzc is '当月存款利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dyftpzysr is '当月FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dyckftpyyjsr is '当月存款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ljcklxzc is '累计存款利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ljftpzysr is '累计FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ljckftpyyjsr is '累计存款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dkqmye is '贷款期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dkdyrj is '贷款当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dkljrj is '贷款累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dydklxsr is '当月贷款利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dydkftpzycb is '当月贷款FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.dydkftpyyjsr is '当月贷款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ljdklxsr is '累计贷款利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ljdkftpzycb is '累计贷款FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ljdkftpyyjsr is '累计贷款FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxdqmye is '类信贷期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxddyrj is '类信贷当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxdljrj is '类信贷累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxddylxsr is '类信贷当月利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxddyftpzycb is '类信贷当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxddyftpjsr is '类信贷当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxdljlxsr is '类信贷累计利息收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxdljftpzycb is '类信贷累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.lxdljftpjsr is '类信贷累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxqmye is '再贴现期末余额';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxdyrj is '再贴现当月日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxljrj is '再贴现累计日均';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxdylxzc is '再贴现当月利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxdyftpzysr is '再贴现当月FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxdyftpjsr is '再贴现当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxljlxzc is '再贴现累计利息支出';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxljftpzysr is '再贴现累计FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ztxljftpyyjsr is '再贴现累计FTP营业净收入';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_khftpcl_recal.etl_timestamp is 'ETL处理时间戳';
