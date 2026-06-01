/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_jjksqdfymx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_jjksqdfymx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_jjksqdfymx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_jjksqdfymx_recal(
    tjrq number(22) -- 统计日期
    ,jyrq number(22) -- 交易日期
    ,jjgsbh varchar2(300) -- 基金公司编号
    ,jjgsmc varchar2(2250) -- 基金公司名称
    ,khjgdh varchar2(300) -- 开户机构代号
    ,khjgmc varchar2(1500) -- 开户机构名称
    ,ssjgkhdxdh number(22) -- 所属机构考核对象代号
    ,ssjgdh varchar2(300) -- 所属机构代号
    ,ssjgmc varchar2(1500) -- 所属机构名称
    ,kmh varchar2(180) -- 科目号
    ,kmmc varchar2(300) -- 科目名称
    ,lxszkmh varchar2(180) -- 利息收支科目号
    ,lxszkmmc varchar2(300) -- 利息收支科目名称
    ,zlbl number(30,4) -- 认领比例
    ,jyje number(30,4) -- 交易金额
    ,zhye number(30,4) -- 基金快赎余额
    ,zhyeylj number(30,4) -- 账户余额月累计
    ,zhyrj number(30,4) -- 月日均余额
    ,zhyenlj number(30,4) -- 账户余额年累计
    ,zhnrj number(30,4) -- 年日均余额
    ,ftpjg number(30,4) -- FTP价格
    ,ftpsrylj number(30,4) -- FTP收入月累计
    ,ftpsrnlj number(30,4) -- FTP收入年累计
    ,tzhftpjg number(30,4) -- 调整后FTP价格
    ,tzhftpsrylj number(30,4) -- 调整后FTP收入月累计
    ,tzhftpsrnlj number(30,4) -- 调整后FTP收入年累计
    ,qdfyylj number(30,4) -- 渠道费用月累计
    ,qdfynlj number(30,4) -- 渠道费用年累计
    ,ylfyylj number(30,4) -- 银联费用月累计
    ,ylfynlj number(30,4) -- 银联费用年累计
    ,ftpsyylj number(30,4) -- FTP收益月累计
    ,ftpsynlj number(30,4) -- FTP收益年累计
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_jjksqdfymx_recal is '基金快赎业务明细报表_重算';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.jjgsbh is '基金公司编号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.jjgsmc is '基金公司名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.lxszkmh is '利息收支科目号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.lxszkmmc is '利息收支科目名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.jyje is '交易金额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.zhye is '基金快赎余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.zhyeylj is '账户余额月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.zhyrj is '月日均余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.zhyenlj is '账户余额年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.zhnrj is '年日均余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.tzhftpjg is '调整后FTP价格';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.tzhftpsrylj is '调整后FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.tzhftpsrnlj is '调整后FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.qdfyylj is '渠道费用月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.qdfynlj is '渠道费用年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ylfyylj is '银联费用月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ylfynlj is '银联费用年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx_recal.etl_timestamp is 'ETL处理时间戳';
