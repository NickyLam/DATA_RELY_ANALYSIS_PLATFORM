/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_wlckftpmx_xy_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal(
    tjrq number(22) -- 统计日期
    ,zhhm varchar2(300) -- 账户名称
    ,zhdh varchar2(150) -- 账户代号
    ,zzh varchar2(150) -- 子账号
    ,kh varchar2(300) -- 卡号
    ,khh varchar2(300) -- 客户号
    ,khjgdh varchar2(150) -- 开户机构代号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,kmh varchar2(150) -- 科目号
    ,kmmc varchar2(300) -- 科目名称
    ,qxmc varchar2(300) -- 期限名称
    ,cph varchar2(150) -- 产品号
    ,cpejfl varchar2(150) -- 产品二级分类
    ,cpsjfl varchar2(150) -- 产品四级分类
    ,cpsijfl varchar2(150) -- 产品四级分类
    ,cpmc varchar2(300) -- 产品名称
    ,zxll number(15,7) -- 执行利率
    ,sjll number(15,7) -- 新型存款实际利率
    ,qxrq number(22) -- 起息日期
    ,dqrq number(22) -- 到期日期
    ,xhrq number(22) -- 销户日期
    ,zzkzqr varchar2(60) -- 最早可支取日
    ,sfzy varchar2(30) -- 是否质押
    ,sfhx varchar2(600) -- 是否核心
    ,bz varchar2(90) -- 币种
    ,ye number(25,4) -- 余额
    ,dyrj number(25,4) -- 当月日均
    ,ljrj number(25,4) -- 累计日均
    ,dylxzc number(25,4) -- 当月利息支出
    ,ljlxzc number(25,4) -- 累计利息支出
    ,ftpjg number(25,4) -- FTP价格
    ,dyftpzysr number(25,4) -- 当月FTP转移收入
    ,ljftpzysr number(25,4) -- 累计FTP转移收入
    ,dyftpjsy number(25,4) -- 当月FTP净收益
    ,ljftpjsy number(25,4) -- 累计FTP净收益
    ,zjywsr number(25,4) -- 中间业务收入
    ,bzdm varchar2(30) -- 币种代码
    ,khjldh varchar2(150) -- 客户经理工号
    ,ssjgdh varchar2(150) -- 所属机构代号
    ,fpbl number(15,4) -- 分配比例
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
grant select on ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal is '网络贷款明细_重算';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.zhhm is '账户名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.kh is '卡号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.qxmc is '期限名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.cph is '产品号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.sjll is '新型存款实际利率';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.sfhx is '是否核心';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.dyrj is '当月日均';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.ljrj is '累计日均';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.dylxzc is '当月利息支出';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.ljlxzc is '累计利息支出';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.dyftpzysr is '当月FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.ljftpzysr is '累计FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.khjldh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_wlckftpmx_xy_recal.etl_timestamp is 'ETL处理时间戳';
