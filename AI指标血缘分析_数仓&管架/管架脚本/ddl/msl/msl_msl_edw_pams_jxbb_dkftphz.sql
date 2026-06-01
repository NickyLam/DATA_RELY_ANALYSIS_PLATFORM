/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_dkftphz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_dkftphz
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_dkftphz purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_dkftphz(
    etl_dt date
    ,tjrq number(22)
    ,kmh varchar2(300)
    ,kmmc varchar2(300)
    ,cpbh varchar2(300)
    ,cpzwmc varchar2(300)
    ,ye number(25,4)
    ,yrj number(25,4)
    ,nrj number(25,4)
    ,jqll number(25,10)
    ,ylx number(25,4)
    ,nlx number(25,4)
    ,jqftpjg number(25,10)
    ,dyftpzycb number(25,4)
    ,ljftpzycb number(25,4)
    ,dyftpjsy number(25,4)
    ,ljftpjsy number(25,4)
    ,lxkm varchar2(150)
    ,lxkmmc varchar2(300)
    ,khjgh varchar2(150)
    ,khjgmc varchar2(300)
    ,ssjgh varchar2(150)
    ,ssjgmc varchar2(300)
    ,yqxyss number(26,5)
    ,fxjqzcje number(25,4)
    ,bz varchar2(90)
    ,frje number(25,4)
    ,hyfrje number(25,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_dkftphz to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_dkftphz is '绩效报表_贷款FTP汇总';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.kmh is '科目号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.kmmc is '科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.cpbh is '标准产品编号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.cpzwmc is '产品中文名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.ye is '余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.yrj is '月日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.nrj is '年日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.jqll is '加权利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.ylx is '月利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.nlx is '年利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.jqftpjg is '加权ftp价格';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.dyftpzycb is '当月ftp转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.ljftpzycb is '累计ftp转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.dyftpjsy is '当月ftp净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.ljftpjsy is '累计ftp净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.lxkm is '利息科目';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.lxkmmc is '利息科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.khjgh is '开户机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.khjgmc is '开户机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.ssjgh is '所属机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.ssjgmc is '所属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.yqxyss is '预计信用损失';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.fxjqzcje is '风险加权资产金额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.bz is '币种';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.frje is '分润金额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftphz.hyfrje is '行员分润金额';
