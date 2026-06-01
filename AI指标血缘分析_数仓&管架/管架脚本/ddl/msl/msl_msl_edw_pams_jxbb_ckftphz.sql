/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_ckftphz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_ckftphz
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_ckftphz purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_ckftphz(
    etl_dt date
    ,tjrq number(22)
    ,kmh varchar2(75)
    ,kmmc varchar2(150)
    ,cpmc varchar2(150)
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
    ,lxkm varchar2(75)
    ,lxkmmc varchar2(150)
    ,khjgh varchar2(75)
    ,khjgmc varchar2(150)
    ,ssjgh varchar2(75)
    ,ssjgmc varchar2(150)
    ,bz varchar2(45)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_ckftphz to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_ckftphz is '存款ftp汇总表';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.kmh is '科目号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.kmmc is '科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.cpmc is '产品名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.zhye is '账户余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.zhyrjye is '账户月日均余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.zhnrjye is '账户年日均余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.jqll is '加权利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ftplxzcylj is 'ftp利息支出月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ftplxzcnlj is 'ftp利息支出年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.jqftpjg is '加权ftp价格';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ftpsrylj is 'ftp收入月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ftpsrnlj is 'ftp收入年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ftpsyylj is 'ftp收益月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ftpsynlj is 'ftp收益年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.lxkm is '利息科目';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.lxkmmc is '利息科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.khjgh is '开户机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.khjgmc is '开户机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ssjgh is '所属机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.ssjgmc is '所属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftphz.bz is '币种';
