/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_tyckzzhmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_tyckzzhmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_tyckzzhmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_tyckzzhmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,jgdh varchar2(60) -- 机构代号
    ,jgmc varchar2(150) -- 机构名称
    ,hydh varchar2(60) -- 行员代号
    ,hymc varchar2(150) -- 行员名称
    ,khh varchar2(300) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,jrjglb varchar2(150) -- 金融机构类型
    ,zhdh varchar2(150) -- 账户代号
    ,zhid varchar2(150) -- 账户id
    ,zzh varchar2(150) -- 子账号
    ,khjgdh varchar2(60) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,bz varchar2(30) -- 币种
    ,cz varchar2(150) -- 储种
    ,khrq number(22,0) -- 开户日期
    ,nll number(25,4) -- 年利率
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,fxpl varchar2(150) -- 付息频率
    ,zhye number(25,4) -- 账户余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,kmh varchar2(150) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,ftpll number(25,4) -- 准备金ftp利率
    ,byftpjsr number(25,4) -- 当月ftp净收入
    ,bnftpjsr number(25,4) -- 半年ftp净支出
    ,ljftpjsr number(25,4) -- 累计ftp季收入
    ,fpjs varchar2(3) -- 分配角色
    ,fpbl number(25,4) -- 分配比例
    ,lxzcylj number(25,4) -- 利息支出月累计
    ,lxzcnlj number(25,4) -- 利息支出年累计
    ,lxsrylj number(25,4) -- 利息收入月累计
    ,lxsrnlj number(25,4) -- 利息收入年累计
    ,lxzcrlj number(25,4) -- 利息支出日累计
    ,lxsrrlj number(25,4) -- 利息收入日累计
    ,brftpjsr number(25,4) -- 当日FTP净收入
    ,fptx varchar2(15) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,qylx varchar2(60) -- 签约类型
    ,cph varchar2(180) -- 产品编号
    ,cpejfl varchar2(900) -- 产品小类（二级分类）
    ,cpsjfl varchar2(900) -- 产品组（三级分类）
    ,cpsijfl varchar2(900) -- 基础产品（四级分类）
    ,cpzwmc varchar2(900) -- 可售产品（产品名称）
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
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_tyckzzhmx is '绩效报表_同业存款子账户明细';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.jrjglb is '金融机构类型';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.zhid is '账户id';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.cz is '储种';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.nll is '年利率';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.fxpl is '付息频率';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.ftpll is '准备金ftp利率';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.byftpjsr is '当月ftp净收入';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.bnftpjsr is '半年ftp净支出';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.ljftpjsr is '累计ftp季收入';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.lxzcylj is '利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.lxzcnlj is '利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.lxsrylj is '利息收入月累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.lxsrnlj is '利息收入年累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.lxzcrlj is '利息支出日累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.lxsrrlj is '利息收入日累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.brftpjsr is '当日FTP净收入';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.qylx is '签约类型';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.cph is '产品编号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.cpejfl is '产品小类（二级分类）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.cpsjfl is '产品组（三级分类）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.cpsijfl is '基础产品（四级分类）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.cpzwmc is '可售产品（产品名称）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx.etl_timestamp is 'ETL处理时间戳';
