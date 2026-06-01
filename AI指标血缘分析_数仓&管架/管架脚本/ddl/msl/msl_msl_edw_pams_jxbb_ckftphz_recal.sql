/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_ckftphz_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal(
    etl_dt date
    ,tjrq number(22)
    ,kmh varchar2(150)
    ,kmmc varchar2(300)
    ,cpmc varchar2(300)
    ,zhye number(25,4)
    ,zhyrjye number(25,4)
    ,zhnrjye number(25,4)
    ,jqll number(25,4)
    ,ftplxzcylj number(25,4)
    ,ftplxzcnlj number(25,4)
    ,jqftpjg number(25,4)
    ,ftpsrylj number(25,4)
    ,ftpsrnlj number(25,4)
    ,ftpsyylj number(25,4)
    ,ftpsynlj number(25,4)
    ,lxkm varchar2(150)
    ,lxkmmc varchar2(300)
    ,khjgh varchar2(150)
    ,khjgmc varchar2(300)
    ,ssjgh varchar2(150)
    ,ssjgmc varchar2(300)
    ,bz varchar2(90)
    ,recal_dt number(22)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal is '绩效报表-存款FTP汇总(供数)_重算';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.kmh is '科目号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.kmmc is '科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.cpmc is '产品名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.zhye is '账户余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.zhyrjye is '账户月日均余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.zhnrjye is '账户年日均余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.jqll is '加权利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ftplxzcylj is 'ftp利息支出月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ftplxzcnlj is 'ftp利息支出年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.jqftpjg is '加权ftp价格';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ftpsrylj is 'ftp收入月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ftpsrnlj is 'ftp收入年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ftpsyylj is 'ftp收益月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ftpsynlj is 'ftp收益年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.lxkm is '利息科目';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.lxkmmc is '利息科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.khjgh is '开户机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.khjgmc is '开户机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ssjgh is '所属机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.ssjgmc is '所属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.bz is '币种';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz_recal.recal_dt is '重算日期';
