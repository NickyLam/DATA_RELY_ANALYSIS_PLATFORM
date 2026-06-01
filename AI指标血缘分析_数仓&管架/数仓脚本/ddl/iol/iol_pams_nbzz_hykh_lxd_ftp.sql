/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_hykh_lxd_ftp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_hykh_lxd_ftp
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_hykh_lxd_ftp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_hykh_lxd_ftp(
    tjrq number(22,0) -- 统计日期
    ,khdxdh number(22,0) -- 考核对象代号
    ,jrgjbh varchar2(90) -- 金融机构编号
    ,bz varchar2(45) -- 币种
    ,ftpll number(30,8) -- ftp利率
    ,ftplxzcrlj number(30,8) -- ftp利息支出日累计
    ,ftplxzcylj number(30,8) -- ftp利息支出月累计
    ,ftplxzcnlj number(30,8) -- ftp利息支出年累计
    ,ftplxsrrlj number(30,8) -- ftp利息收入日累计
    ,ftplxsrylj number(30,8) -- ftp利息收入月累计
    ,ftplxsrnlj number(30,8) -- ftp利息收入年累计
    ,ftpjsrrlj number(30,8) -- ftp净收入日累计
    ,ftpjsrylj number(30,8) -- ftp净收入月累计
    ,ftpjsrnlj number(30,8) -- ftp净收入年累计
    ,fphftplxzcrlj number(25,4) -- 分配后ftp利息支出日累计
    ,fphftplxzcylj number(25,4) -- 分配后ftp利息支出月累计
    ,fphftplxzcnlj number(25,4) -- 分配后ftp利息支出年累计
    ,fphftplxsrrlj number(25,4) -- 分配后ftp利息收入日累计
    ,fphftplxsrylj number(25,4) -- 分配后ftp利息收入月累计
    ,fphftplxsrnlj number(25,4) -- 分配后ftp利息收入年累计
    ,fphftpjsrrlj number(25,4) -- 分配后ftp净收入日累计
    ,fphftpjsrylj number(25,4) -- 分配后ftp净收入月累计
    ,fphftpjsrnlj number(25,4) -- 分配后ftp净收入年累计
    ,fpbl number(25,4) -- 分配比例
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
grant select on ${iol_schema}.pams_nbzz_hykh_lxd_ftp to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_hykh_lxd_ftp to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_hykh_lxd_ftp to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_hykh_lxd_ftp to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_hykh_lxd_ftp is '内部总账_行员考核_类信贷_FTP';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.jrgjbh is '金融机构编号';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftpll is 'ftp利率';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftplxzcrlj is 'ftp利息支出日累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftplxzcylj is 'ftp利息支出月累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftplxzcnlj is 'ftp利息支出年累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftplxsrrlj is 'ftp利息收入日累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftplxsrylj is 'ftp利息收入月累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftplxsrnlj is 'ftp利息收入年累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftpjsrrlj is 'ftp净收入日累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftpjsrylj is 'ftp净收入月累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.ftpjsrnlj is 'ftp净收入年累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftplxzcrlj is '分配后ftp利息支出日累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftplxzcylj is '分配后ftp利息支出月累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftplxzcnlj is '分配后ftp利息支出年累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftplxsrrlj is '分配后ftp利息收入日累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftplxsrylj is '分配后ftp利息收入月累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftplxsrnlj is '分配后ftp利息收入年累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftpjsrrlj is '分配后ftp净收入日累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftpjsrylj is '分配后ftp净收入月累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fphftpjsrnlj is '分配后ftp净收入年累计';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.fpbl is '分配比例';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_hykh_lxd_ftp.etl_timestamp is 'ETL处理时间戳';
