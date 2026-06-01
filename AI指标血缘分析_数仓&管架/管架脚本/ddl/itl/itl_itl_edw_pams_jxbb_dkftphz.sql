/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_jxbb_dkftphz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_jxbb_dkftphz
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_jxbb_dkftphz purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_jxbb_dkftphz(
    tjrq number(22) -- 统计日期
    ,kmh varchar2(300) -- 科目号
    ,kmmc varchar2(300) -- 科目名称
    ,cpbh varchar2(300) -- 标准产品编号
    ,cpzwmc varchar2(300) -- 产品中文名称
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,jqll number(25,10) -- 加权利率
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,jqftpjg number(25,10) -- 加权ftp价格
    ,dyftpzycb number(25,4) -- 当月ftp转移成本
    ,ljftpzycb number(25,4) -- 累计ftp转移成本
    ,dyftpjsy number(25,4) -- 当月ftp净收益
    ,ljftpjsy number(25,4) -- 累计ftp净收益
    ,lxkm varchar2(150) -- 利息科目
    ,lxkmmc varchar2(300) -- 利息科目名称
    ,khjgh varchar2(150) -- 开户机构号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,ssjgh varchar2(150) -- 所属机构号
    ,ssjgmc varchar2(300) -- 所属机构名称
    ,yqxyss number(26,5) -- 预计信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,bz varchar2(90) -- 币种
    ,frje number(25,4) -- 分润金额
    ,hyfrje number(25,4) -- 行员分润金额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pams_jxbb_dkftphz to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_jxbb_dkftphz is '绩效报表_贷款FTP汇总';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.tjrq is '统计日期';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.kmh is '科目号';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.kmmc is '科目名称';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.cpbh is '标准产品编号';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.cpzwmc is '产品中文名称';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.ye is '余额';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.yrj is '月日均';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.nrj is '年日均';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.jqll is '加权利率';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.ylx is '月利息';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.nlx is '年利息';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.jqftpjg is '加权ftp价格';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.dyftpzycb is '当月ftp转移成本';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.ljftpzycb is '累计ftp转移成本';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.dyftpjsy is '当月ftp净收益';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.ljftpjsy is '累计ftp净收益';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.lxkm is '利息科目';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.lxkmmc is '利息科目名称';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.khjgh is '开户机构号';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.khjgmc is '开户机构名称';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.ssjgh is '所属机构号';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.ssjgmc is '所属机构名称';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.yqxyss is '预计信用损失';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.fxjqzcje is '风险加权资产金额';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.bz is '币种';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.frje is '分润金额';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.hyfrje is '行员分润金额';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_jxbb_dkftphz.etl_timestamp is 'ETL处理时间戳';
