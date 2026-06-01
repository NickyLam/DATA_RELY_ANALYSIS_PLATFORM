/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_tycdmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_tycdmx
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_tycdmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_tycdmx(
    etl_dt date
    ,tjrq number(22)
    ,jxdxdh number(22)
    ,khdxdh number(22)
    ,jgkhdxdh number(22)
    ,jgdh varchar2(15)
    ,jgmc varchar2(75)
    ,hydh varchar2(30)
    ,hymc varchar2(75)
    ,ywbh varchar2(75)
    ,cddm varchar2(75)
    ,cdjc varchar2(150)
    ,ssjgkhdxdh number(22)
    ,ssjgdh varchar2(30)
    ,ssjgmc varchar2(75)
    ,fxrq number(22)
    ,qxrq number(22)
    ,dqrq number(22)
    ,dfrq number(22)
    ,qx varchar2(30)
    ,jxts number(22)
    ,fxjg number(38,8)
    ,nll number(25,4)
    ,fxl number(38,8)
    ,fxje number(38,8)
    ,bqye number(25,4)
    ,sjtzrkhh varchar2(75)
    ,sjtzrqc varchar2(150)
    ,fxjgmc varchar2(75)
    ,xsjgmc varchar2(75)
    ,nrj number(25,4)
    ,yrj number(25,4)
    ,nzc number(25,4)
    ,yzc number(25,4)
    ,ftpll number(25,4)
    ,dyftpjsr number(25,4)
    ,ljftpjsr number(25,4)
    ,fpbl number(25,4)
    ,fpjs varchar2(3)
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
    ,cpdm varchar2(90)
    ,fptx varchar2(15)
    ,txfpbl number(19,5)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_tycdmx to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_tycdmx is '绩效报表_同业存单明细';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.etl_dt is 'etl处理日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.jxdxdh is '绩效对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.khdxdh is '考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.jgkhdxdh is '机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.jgdh is '机构代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.jgmc is '机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.hydh is '行员代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.hymc is '行员名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ywbh is '业务编号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.cddm is '存单代码';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.cdjc is '存单简称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ssjgdh is '所属机构代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ssjgmc is '所属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fxrq is '发行日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.qxrq is '起息日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.dqrq is '到期日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.dfrq is '兑付日';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.qx is '期限';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.jxts is '计息天数';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fxjg is '发行机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.nll is '年利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fxl is '发行量(元)';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fxje is '发行金额(元)';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.bqye is '本期余额(元)';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.sjtzrkhh is '实际投资人客户号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.sjtzrqc is '实际投资人全称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fxjgmc is '发行机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.xsjgmc is '销售机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.nrj is '年日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.yrj is '月日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.nzc is '年支出';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.yzc is '月支出';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ftpll is '准备金ftp利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.dyftpjsr is '当月ftp季收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ljftpjsr is '累计ftp季收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fpbl is '分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fpjs is '分配角色';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ftplxsrylj is 'ftp利息收入月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ftplxsrnlj is 'ftp利息收入年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.rzc is '日支出';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.drftpjsr is '当日ftp净收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.dnftpjsr is '当年ftp净收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.ftplxsr is 'ftp利息收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.xsjgmczh is '销售机构名称组合';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.xsjgmczb is '销售机构占比说明';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.gsjgmczh is '归属机构名称组合';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.gsjgmczb is '归属机构占比说明';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.cpdm is '产品代码';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.fptx is '所属条线';
comment on column ${msl_schema}.msl_edw_pams_jxbb_tycdmx.txfpbl is '条线分配比例';
