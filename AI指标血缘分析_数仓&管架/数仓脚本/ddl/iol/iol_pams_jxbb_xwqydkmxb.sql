/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_xwqydkmxb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_xwqydkmxb
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_xwqydkmxb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_xwqydkmxb(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,jgdh varchar2(15) -- 机构代号
    ,jgmc varchar2(150) -- 机构名称
    ,jjh varchar2(150) -- 借据号
    ,khh varchar2(45) -- 客户号
    ,khmc varchar2(750) -- 客户名称
    ,dklx varchar2(2) -- 贷款类型
    ,sfxw varchar2(300) -- 是否小微标识
    ,ywpz varchar2(150) -- 业务配置
    ,kmh varchar2(30) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,ffrq number(22,0) -- 发放日期
    ,dqrq number(22,0) -- 到期日期
    ,bzzwmc varchar2(750) -- 币种
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
    ,khdxdh number(22,0) -- 考核对象代号
    ,hydh varchar2(18) -- 客户经理工号
    ,hymc varchar2(150) -- 客户经理名称
    ,ssjgkhdxdh number(22,0) -- 所属机构考核对象代号
    ,ssjgdh varchar2(15) -- 所属机构号
    ,ssjgmc varchar2(150) -- 所属机构名称
    ,fpje number(25,4) -- 分配总金额
    ,zlbl number(19,5) -- 分配比例
    ,fphzcye number(19,5) -- 分配后正常余额
    ,fphzcyrj number(19,5) -- 分配后正常月日均
    ,fphzcjrj number(19,5) -- 分配后正常季日均
    ,fphzcnrj number(19,5) -- 分配后正常年日均
    ,fphyqye number(19,5) -- 分配后逾期余额
    ,fphyqyrj number(19,5) -- 分配后逾期月日均
    ,fphyqjrj number(19,5) -- 分配后逾期季日均
    ,fphyqnrj number(19,5) -- 分配后逾期年日均
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
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_xwqydkmxb to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_xwqydkmxb is '小微企业贷款明细表';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.dklx is '贷款类型';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.sfxw is '是否小微标识';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ywpz is '业务配置';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ffrq is '发放日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.bzzwmc is '币种';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.dkje is '贷款金额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.zcye is '正常余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.zcyrj is '正常月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.zcjrj is '正常季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.zcnrj is '正常年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.yqye is '逾期余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.yqyrj is '逾期月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.yqjrj is '逾期季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.yqnrj is '逾期年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.nll is '年利率';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.hydh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.hymc is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fpje is '分配总金额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.zlbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphzcye is '分配后正常余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphzcyrj is '分配后正常月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphzcjrj is '分配后正常季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphzcnrj is '分配后正常年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphyqye is '分配后逾期余额';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphyqyrj is '分配后逾期月日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphyqjrj is '分配后逾期季日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.fphyqnrj is '分配后逾期年日均';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.gyljrywbz is '供应链金融业务标志';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ftplxsr is 'FTP利息收入';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ftpzycb is 'FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.xbcxdbs is '1+N信保贷标识';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_xwqydkmxb.etl_timestamp is 'ETL处理时间戳';
