/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_tycdmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal(
    etl_dt date
    ,tjrq number(22)
    ,jxdxdh number(22)
    ,khdxdh number(22)
    ,jgkhdxdh number(22)
    ,jgdh varchar2(30)
    ,jgmc varchar2(150)
    ,hydh varchar2(60)
    ,hymc varchar2(150)
    ,ywbh varchar2(150)
    ,cddm varchar2(150)
    ,cdjc varchar2(300)
    ,ssjgkhdxdh number(22)
    ,ssjgdh varchar2(60)
    ,ssjgmc varchar2(150)
    ,fxrq number(22)
    ,qxrq number(22)
    ,dqrq number(22)
    ,dfrq number(22)
    ,qx varchar2(60)
    ,jxts number(22)
    ,fxjg number(38,8)
    ,nll number(25,4)
    ,fxl number(38,8)
    ,fxje number(38,8)
    ,bqye number(25,4)
    ,sjtzrkhh varchar2(150)
    ,sjtzrqc varchar2(300)
    ,fxjgmc varchar2(150)
    ,xsjgmc varchar2(150)
    ,nrj number(25,4)
    ,yrj number(25,4)
    ,nzc number(25,4)
    ,yzc number(25,4)
    ,ftpll number(25,4)
    ,dyftpjsr number(25,4)
    ,ljftpjsr number(25,4)
    ,fpbl number(25,4)
    ,fpjs varchar2(6)
    ,ftplxsrylj number(25,4)
    ,ftplxsrnlj number(25,4)
    ,rzc number(25,4)
    ,drftpjsr number(25,4)
    ,dnftpjsr number(25,4)
    ,ftplxsr number(25,4)
    ,xsjgmczh varchar2(4000)
    ,xsjgmczb varchar2(4000)
    ,gsjgmczh varchar2(4000)
    ,gsjgmczb varchar2(4000)
    ,cpdm varchar2(180)
    ,fptx varchar2(30)
    ,txfpbl number(19,5)
    ,cjdrgjgkhh varchar2(300)
    ,cjdrgjg varchar2(300)
    ,sjrgfkhh varchar2(300)
    ,sjrgfqc varchar2(300)
    ,tycb number(25,4)
    ,recal_dt number(22)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal is '绩效报表_同业存单明细_重算';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.jxdxdh is '绩效对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.khdxdh is '考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.jgdh is '机构代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.jgmc is '机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.hydh is '行员代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.hymc is '行员名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ywbh is '业务编号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.cddm is '存单代码';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.cdjc is '存单简称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ssjgdh is '所属机构代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ssjgmc is '所属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fxrq is '发行日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.qxrq is '起息日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.dqrq is '到期日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.dfrq is '兑付日';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.qx is '期限';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.jxts is '计息天数';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fxjg is '发行机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.nll is '年利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fxl is '发行量(元)';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fxje is '发行金额(元)';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.bqye is '本期余额(元)';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.sjtzrkhh is '实际投资人客户号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.sjtzrqc is '实际投资人全称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fxjgmc is '发行机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.xsjgmc is '销售机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.nrj is '年日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.yrj is '月日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.nzc is '年支出';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.yzc is '月支出';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ftpll is '准备金ftp利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.dyftpjsr is '当月ftp季收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ljftpjsr is '累计ftp季收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fpbl is '分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fpjs is '分配角色';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ftplxsrylj is 'ftp利息收入月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ftplxsrnlj is 'ftp利息收入年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.rzc is '当月利息支出';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.drftpjsr is '当日ftp净收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.dnftpjsr is '当年ftp净收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.ftplxsr is 'ftp利息收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.xsjgmczh is '销售机构名称组合';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.xsjgmczb is '销售机构占比说明';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.gsjgmczh is '归属机构名称组合';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.gsjgmczb is '归属机构占比说明';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.cpdm is '产品代码';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.fptx is '所属条线';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.txfpbl is '条线分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.cjdrgjgkhh is '成交单认购机构客户号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.cjdrgjg is '成交单认购机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.sjrgfkhh is '实际认购方客户号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.sjrgfqc is '实际认购方全称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.tycb is '摊余成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal.recal_dt is '重算日期';
