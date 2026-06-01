/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_tycdmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_tycdmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_tycdmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_tycdmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,jgdh varchar2(15) -- 机构代号
    ,jgmc varchar2(75) -- 机构名称
    ,hydh varchar2(30) -- 行员代号
    ,hymc varchar2(75) -- 行员名称
    ,ywbh varchar2(75) -- 业务编号
    ,cddm varchar2(75) -- 存单代码
    ,cdjc varchar2(150) -- 存单简称
    ,ssjgkhdxdh number(22,0) -- 所属机构考核对象代号
    ,ssjgdh varchar2(30) -- 所属机构代号
    ,ssjgmc varchar2(75) -- 所属机构名称
    ,fxrq number(22,0) -- 发行日期
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,dfrq number(22,0) -- 兑付日
    ,qx varchar2(30) -- 期限
    ,jxts number(22,0) -- 计息天数
    ,fxjg number(38,8) -- 发行机构
    ,nll number(25,4) -- 年利率
    ,fxl number(38,8) -- 发行量(元)
    ,fxje number(38,8) -- 发行金额(元)
    ,bqye number(25,4) -- 本期余额(元)
    ,sjtzrkhh varchar2(75) -- 实际投资人客户号
    ,sjtzrqc varchar2(150) -- 实际投资人全称
    ,fxjgmc varchar2(75) -- 发行机构
    ,xsjgmc varchar2(75) -- 销售机构
    ,nrj number(25,4) -- 年日均
    ,yrj number(25,4) -- 月日均
    ,nzc number(25,4) -- 年支出
    ,yzc number(25,4) -- 月支出
    ,ftpll number(25,4) -- 准备金ftp利率
    ,dyftpjsr number(25,4) -- 当月ftp季收入
    ,ljftpjsr number(25,4) -- 累计ftp季收入
    ,fpbl number(25,4) -- 分配比例
    ,fpjs varchar2(3) -- 分配角色
    ,ftplxsrylj number(25,4) -- ftp利息收入月累计
    ,ftplxsrnlj number(25,4) -- ftp利息收入年累计
    ,rzc number(25,4) -- 日支出
    ,drftpjsr number(25,4) -- 当日FTP净收入
    ,dnftpjsr number(25,4) -- 当年FTP净收入
    ,ftplxsr number(25,4) -- ftp利息收入
    ,xsjgmczh varchar2(4000) -- 销售机构名称组合
    ,xsjgmczb varchar2(4000) -- 销售机构占比说明
    ,gsjgmczh varchar2(4000) -- 归属机构名称组合
    ,gsjgmczb varchar2(4000) -- 归属机构占比说明
    ,cpdm varchar2(90) -- 产品代码
    ,fptx varchar2(15) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,cjdrgjgkhh varchar2(100) -- 成交单认购机构客户号
    ,cjdrgjg varchar2(100) -- 成交单认购机构
    ,sjrgfkhh varchar2(100) -- 实际认购方客户号
    ,sjrgfqc varchar2(100) -- 实际认购方全称
    ,tycb number(25,4) -- 摊余成本
    ,btje number(25,4) -- 
    ,btjeylj number(25,4) -- 
    ,btjejlj number(25,4) -- 
    ,btjenlj number(25,4) -- 
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
grant select on ${iol_schema}.pams_jxbb_tycdmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_tycdmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_tycdmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_tycdmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_tycdmx is '绩效报表_同业存单明细';
comment on column ${iol_schema}.pams_jxbb_tycdmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_tycdmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_tycdmx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.cddm is '存单代码';
comment on column ${iol_schema}.pams_jxbb_tycdmx.cdjc is '存单简称';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fxrq is '发行日期';
comment on column ${iol_schema}.pams_jxbb_tycdmx.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_tycdmx.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_tycdmx.dfrq is '兑付日';
comment on column ${iol_schema}.pams_jxbb_tycdmx.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_tycdmx.jxts is '计息天数';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fxjg is '发行机构';
comment on column ${iol_schema}.pams_jxbb_tycdmx.nll is '年利率';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fxl is '发行量(元)';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fxje is '发行金额(元)';
comment on column ${iol_schema}.pams_jxbb_tycdmx.bqye is '本期余额(元)';
comment on column ${iol_schema}.pams_jxbb_tycdmx.sjtzrkhh is '实际投资人客户号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.sjtzrqc is '实际投资人全称';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fxjgmc is '发行机构';
comment on column ${iol_schema}.pams_jxbb_tycdmx.xsjgmc is '销售机构';
comment on column ${iol_schema}.pams_jxbb_tycdmx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_tycdmx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_tycdmx.nzc is '年支出';
comment on column ${iol_schema}.pams_jxbb_tycdmx.yzc is '月支出';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ftpll is '准备金ftp利率';
comment on column ${iol_schema}.pams_jxbb_tycdmx.dyftpjsr is '当月ftp季收入';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ljftpjsr is '累计ftp季收入';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ftplxsrylj is 'ftp利息收入月累计';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ftplxsrnlj is 'ftp利息收入年累计';
comment on column ${iol_schema}.pams_jxbb_tycdmx.rzc is '日支出';
comment on column ${iol_schema}.pams_jxbb_tycdmx.drftpjsr is '当日FTP净收入';
comment on column ${iol_schema}.pams_jxbb_tycdmx.dnftpjsr is '当年FTP净收入';
comment on column ${iol_schema}.pams_jxbb_tycdmx.ftplxsr is 'ftp利息收入';
comment on column ${iol_schema}.pams_jxbb_tycdmx.xsjgmczh is '销售机构名称组合';
comment on column ${iol_schema}.pams_jxbb_tycdmx.xsjgmczb is '销售机构占比说明';
comment on column ${iol_schema}.pams_jxbb_tycdmx.gsjgmczh is '归属机构名称组合';
comment on column ${iol_schema}.pams_jxbb_tycdmx.gsjgmczb is '归属机构占比说明';
comment on column ${iol_schema}.pams_jxbb_tycdmx.cpdm is '产品代码';
comment on column ${iol_schema}.pams_jxbb_tycdmx.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_tycdmx.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_tycdmx.cjdrgjgkhh is '成交单认购机构客户号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.cjdrgjg is '成交单认购机构';
comment on column ${iol_schema}.pams_jxbb_tycdmx.sjrgfkhh is '实际认购方客户号';
comment on column ${iol_schema}.pams_jxbb_tycdmx.sjrgfqc is '实际认购方全称';
comment on column ${iol_schema}.pams_jxbb_tycdmx.tycb is '摊余成本';
comment on column ${iol_schema}.pams_jxbb_tycdmx.btje is '';
comment on column ${iol_schema}.pams_jxbb_tycdmx.btjeylj is '';
comment on column ${iol_schema}.pams_jxbb_tycdmx.btjejlj is '';
comment on column ${iol_schema}.pams_jxbb_tycdmx.btjenlj is '';
comment on column ${iol_schema}.pams_jxbb_tycdmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_tycdmx.etl_timestamp is 'ETL处理时间戳';
