/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_jjksqdfymx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_jjksqdfymx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_jjksqdfymx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_jjksqdfymx(
    tjrq number(22) -- 统计日期
    ,jyrq number(22) -- 交易日期
    ,jjgsbh varchar2(150) -- 基金公司编号
    ,jjgsmc varchar2(1125) -- 基金公司名称
    ,khjgdh varchar2(150) -- 开户机构代号
    ,khjgmc varchar2(750) -- 开户机构名称
    ,ssjgkhdxdh number(22) -- 所属机构考核对象代号
    ,ssjgdh varchar2(150) -- 所属机构代号
    ,ssjgmc varchar2(750) -- 所属机构名称
    ,kmh varchar2(90) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,lxszkmh varchar2(90) -- 利息收支科目号
    ,lxszkmmc varchar2(150) -- 利息收支科目名称
    ,zlbl number(30,4) -- 分配比例
    ,jyje number(30,4) -- 交易金额
    ,zhye number(30,4) -- 时点余额
    ,zhyeylj number(30,4) -- 当月累计余额
    ,zhyrj number(30,4) -- 月日均余额
    ,zhyenlj number(30,4) -- 当年累计余额
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
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_jjksqdfymx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_jjksqdfymx is '基金快赎业务明细报表';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.jjgsbh is '基金公司编号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.jjgsmc is '基金公司名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.lxszkmh is '利息收支科目号';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.lxszkmmc is '利息收支科目名称';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.zlbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.jyje is '交易金额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.zhye is '时点余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.zhyeylj is '当月累计余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.zhyrj is '月日均余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.zhyenlj is '当年累计余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.zhnrj is '年日均余额';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.tzhftpjg is '调整后FTP价格';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.tzhftpsrylj is '调整后FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.tzhftpsrnlj is '调整后FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.qdfyylj is '渠道费用月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.qdfynlj is '渠道费用年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ylfyylj is '银联费用月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ylfynlj is '银联费用年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_jjksqdfymx.etl_timestamp is 'ETL处理时间戳';
