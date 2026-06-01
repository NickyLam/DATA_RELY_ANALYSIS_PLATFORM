/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_lxdftpmx_bak
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_lxdftpmx_bak
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_lxdftpmx_bak purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_lxdftpmx_bak(
    tjrq number(22,0) -- 统计日期
    ,jrgjbh varchar2(50) -- 金融工具编号
    ,khmc varchar2(500) -- 客户名称
    ,khh varchar2(100) -- 客户号
    ,jydf varchar2(100) -- 交易对方
    ,jyr number(22,0) -- 交易日
    ,dqr number(22,0) -- 到期日
    ,bzdm varchar2(10) -- 币种代码
    ,bz varchar2(30) -- 币种
    ,tzje number(25,4) -- 投资金额
    ,qmye number(25,4) -- 期末余额
    ,dyrj number(25,4) -- 当月日均
    ,ljrj number(25,4) -- 累计日均
    ,yqsyl number(25,4) -- 预期收益率
    ,ftpjg number(25,4) -- FTP价格
    ,jxfs varchar2(30) -- 付息频率
    ,tzlx varchar2(30) -- 投资类型
    ,ssfhhh varchar2(30) -- 财务机构
    ,ssfh varchar2(100) -- 财务机构名称
    ,dylxsr number(25,4) -- 当月利息收入
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,dyftpjsr number(25,4) -- 当月FTP净收入
    ,ljlxsr number(25,4) -- 累计利息收入
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,ljftpjsr number(25,4) -- 累计FTP净收入
    ,ssjgdh varchar2(30) -- 所属机构号
    ,ssjgmc varchar2(100) -- 所属机构名称
    ,khjlxm varchar2(100) -- 客户经理姓名
    ,khjlgh varchar2(30) -- 客户经理工号
    ,fpbl number(25,4) -- 分配比例
    ,fphtzje number(25,4) -- 分配后投资金额
    ,fphqmye number(25,4) -- 分配后期末余额
    ,fphdyrj number(25,4) -- 分配后当月日均
    ,fphljrj number(25,4) -- 分配后累计日均
    ,fphdylxsr number(25,4) -- 分配后当月利息收入
    ,fphdyftpzycb number(25,4) -- 分配后当月FTP转移成本
    ,fphdyftpjsr number(25,4) -- 分配后当月FTP净收入
    ,fphljlxsr number(25,4) -- 分配后累计利息收入
    ,fphljftpzycb number(25,4) -- 分配后累计FTP转移成本
    ,fphljftpjsr number(25,4) -- 分配后累计FTP净收入
    ,wjfl varchar2(1) -- 五级分类
    ,yqxyss number(25,4) -- 逾期信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
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
grant select on ${iol_schema}.pams_jxbb_lxdftpmx_bak to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_lxdftpmx_bak to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_lxdftpmx_bak to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_lxdftpmx_bak to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_lxdftpmx_bak is '类信贷ftp明细表_重算';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.jrgjbh is '金融工具编号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.jydf is '交易对方';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.jyr is '交易日';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.tzje is '投资金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.qmye is '期末余额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.dyrj is '当月日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ljrj is '累计日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.yqsyl is '预期收益率';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.jxfs is '付息频率';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.tzlx is '投资类型';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ssfhhh is '财务机构';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ssfh is '财务机构名称';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.dylxsr is '当月利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.dyftpjsr is '当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ljlxsr is '累计利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ljftpjsr is '累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.khjlxm is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphtzje is '分配后投资金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphqmye is '分配后期末余额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphdyrj is '分配后当月日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphljrj is '分配后累计日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphdylxsr is '分配后当月利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphdyftpzycb is '分配后当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphdyftpjsr is '分配后当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphljlxsr is '分配后累计利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphljftpzycb is '分配后累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fphljftpjsr is '分配后累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.yqxyss is '逾期信用损失';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx_bak.etl_timestamp is 'ETL处理时间戳';
