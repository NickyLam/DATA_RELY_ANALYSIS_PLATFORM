/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_xwqydkmxb_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_xwqydkmxb_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_xwqydkmxb_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_xwqydkmxb_recal(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,jgdh varchar2(30) -- 机构代号
    ,jgmc varchar2(300) -- 机构名称
    ,jjh varchar2(300) -- 借据号
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,dklx varchar2(3) -- 贷款类型
    ,sfxw varchar2(600) -- 是否小微
    ,ywpz varchar2(300) -- 业务品种
    ,kmh varchar2(60) -- 科目号
    ,kmmc varchar2(300) -- 科目名称
    ,ffrq number(22) -- 发放日期
    ,dqrq number(22) -- 到期日期
    ,bzzwmc varchar2(1500) -- 币种中文名称
    ,dkje number(25,4) -- 贷款金额
    ,zcye number(25,4) -- 正常余额
    ,zcyrj number(25,4) -- 正常月日均
    ,zcjrj number(25,4) -- 正常季日均
    ,zcnrj number(25,4) -- 正常年日均
    ,yqye number(25,4) -- 逾期余额
    ,yqyrj number(25,4) -- 逾期月日均
    ,yqjrj number(25,4) -- 逾期季日均
    ,yqnrj number(25,4) -- 逾期年日均
    ,nll number(15,7) -- 年利率
    ,jzll number(25,4) -- 基准利率
    ,khdxdh number(22) -- 考核对象代号
    ,hydh varchar2(36) -- 行员代号
    ,hymc varchar2(300) -- 行员名称
    ,ssjgkhdxdh number(22) -- 所属机构考核对象代号
    ,ssjgdh varchar2(30) -- 所属机构代号
    ,ssjgmc varchar2(300) -- 所属机构名称
    ,fpje number(25,4) -- 分配金额
    ,zlbl number(19,5) -- 认领比例
    ,fphzcye number(25,4) -- 分配后支出余额
    ,fphzcyrj number(25,4) -- 分配后支出月日均
    ,fphzcjrj number(25,4) -- 分配后支出季日均
    ,fphzcnrj number(25,4) -- 分配后支出年日均
    ,fphyqye number(25,4) -- 分配后预期余额
    ,fphyqyrj number(25,4) -- 分配后逾期月日均
    ,fphyqjrj number(25,4) -- 分配后逾期季日均
    ,fphyqnrj number(25,4) -- 分配后逾期年日均
    ,gyljrywbz varchar2(30) -- 供应链金融业务标志
    ,ftplxsr number(25,4) -- FTP利息收入
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,ftpzycb number(25,4) -- FTP转移成本
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,ftpsy number(25,4) -- FTP收益
    ,dyftpjsy number(25,4) -- 当月FTP净收益
    ,ljftpjsy number(25,4) -- 累计FTP净收益
    ,recal_dt number(22) -- 重算日期
    ,xbcxdbs varchar2(30) -- 1+N信保贷标识
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
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_xwqydkmxb_recal is '小微企业贷款明细表_重算';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.dklx is '贷款类型';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.sfxw is '是否小微';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ywpz is '业务品种';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ffrq is '发放日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.bzzwmc is '币种中文名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.dkje is '贷款金额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.zcye is '正常余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.zcyrj is '正常月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.zcjrj is '正常季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.zcnrj is '正常年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.yqye is '逾期余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.yqyrj is '逾期月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.yqjrj is '逾期季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.yqnrj is '逾期年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.nll is '年利率';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fpje is '分配金额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphzcye is '分配后支出余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphzcyrj is '分配后支出月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphzcjrj is '分配后支出季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphzcnrj is '分配后支出年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphyqye is '分配后预期余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphyqyrj is '分配后逾期月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphyqjrj is '分配后逾期季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.fphyqnrj is '分配后逾期年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.gyljrywbz is '供应链金融业务标志';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ftplxsr is 'FTP利息收入';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ftpzycb is 'FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.xbcxdbs is '1+N信保贷标识';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb_recal.etl_timestamp is 'ETL处理时间戳';
