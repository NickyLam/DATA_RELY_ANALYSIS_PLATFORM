/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dkftphz_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dkftphz_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dkftphz_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dkftphz_recal(
    recal_dt number(38,0) -- 重算窗口日期
    ,tjrq number(38,0) -- 统计日期
    ,kmh varchar2(300) -- 科目号
    ,cpbh varchar2(300) -- 产品编号
    ,lxkm varchar2(150) -- 利息科目
    ,khjgh varchar2(150) -- 开户机构号
    ,ssjgh varchar2(150) -- 所属机构号
    ,bz varchar2(90) -- 币种
    ,kmmc varchar2(300) -- 科目名称
    ,cpzwmc varchar2(300) -- 产品中文名称
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,jqll number(25,10) -- 加权利率
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,jqftpjg number(25,10) -- 加权ftp价格
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,dyftpjsy number(25,4) -- 当月FTP净收益
    ,ljftpjsy number(25,4) -- 累计FTP净收益
    ,lxkmmc varchar2(300) -- 利息科目名称
    ,khjgmc varchar2(300) -- 开户机构名称
    ,ssjgmc varchar2(300) -- 所属机构名称
    ,yqxyss number(26,5) -- 预计信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,frje number(25,4) -- 分润金额
    ,hyfrje number(25,4) -- 行员分润金额
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
grant select on ${iol_schema}.pams_jxbb_dkftphz_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dkftphz_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftphz_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftphz_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dkftphz_recal is '绩效报表-贷款FTP汇总表-重算';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.recal_dt is '重算窗口日期';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.ssjgh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.cpzwmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.jqll is '加权利率';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.jqftpjg is '加权ftp价格';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.yqxyss is '预计信用损失';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.frje is '分润金额';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.hyfrje is '行员分润金额';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dkftphz_recal.etl_timestamp is 'ETL处理时间戳';
