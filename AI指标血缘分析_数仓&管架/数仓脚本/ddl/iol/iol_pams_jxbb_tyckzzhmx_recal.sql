/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_tyckzzhmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_tyckzzhmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_tyckzzhmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_tyckzzhmx_recal(
    tjrq number(22) -- 数据入库日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 行员考核对象代号
    ,jgdh varchar2(60) -- 机构号
    ,jgmc varchar2(150) -- 机构名称
    ,hydh varchar2(60) -- 客户经理工号
    ,hymc varchar2(150) -- 行员名称
    ,khh varchar2(300) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,jrjglb varchar2(150) -- 金融机构类型
    ,zhdh varchar2(150) -- 账号ID
    ,zhid varchar2(150) -- 卡号
    ,zzh varchar2(150) -- 子账号
    ,khjgdh varchar2(60) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,bz varchar2(30) -- 币种
    ,cz varchar2(150) -- 储种
    ,khrq number(22) -- 开户日期
    ,nll number(25,4) -- 年利率
    ,qxrq number(22) -- 起息日期
    ,dqrq number(22) -- 到期日期
    ,fxpl varchar2(150) -- 付息频率
    ,zhye number(25,4) -- 账户余额_0C
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,kmh varchar2(150) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,ftpll number(25,4) -- 准备金FTP利率
    ,byftpjsr number(25,4) -- 本月ftp净收入
    ,bnftpjsr number(25,4) -- 半年FTP净支出
    ,ljftpjsr number(25,4) -- 累计FTP季收入
    ,fpjs varchar2(3) -- 分配角色
    ,fpbl number(25,4) -- 分配比例
    ,lxzcylj number(25,4) -- 利息支出月累计
    ,lxzcnlj number(25,4) -- 利息支出年累计
    ,lxsrylj number(25,4) -- 累计利息（月累计）
    ,lxsrnlj number(25,4) -- 累计利息（年累计）
    ,lxzcrlj number(25,4) -- 利息支出日累计
    ,lxsrrlj number(25,4) -- 利息收入日累计
    ,brftpjsr number(25,4) -- 本日ftp净收入
    ,fptx varchar2(30) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,qylx varchar2(60) -- 签约类型
    ,cph varchar2(180) -- 产品编号
    ,cpejfl varchar2(900) -- 产品小类（二级分类）
    ,cpsjfl varchar2(900) -- 产品组（三级分类）
    ,cpsijfl varchar2(900) -- 基础产品（四级分类）
    ,cpzwmc varchar2(900) -- 可售产品（产品名称）
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
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_tyckzzhmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_tyckzzhmx_recal is '绩效报表_同业存款子账户明细_重算';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.tjrq is '数据入库日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.khdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.jgdh is '机构号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.hydh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.jrjglb is '金融机构类型';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.zhdh is '账号ID';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.zhid is '卡号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.cz is '储种';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.nll is '年利率';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.fxpl is '付息频率';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.zhye is '账户余额_0C';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.ftpll is '准备金FTP利率';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.byftpjsr is '本月ftp净收入';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.bnftpjsr is '半年FTP净支出';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.ljftpjsr is '累计FTP季收入';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.lxzcylj is '利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.lxzcnlj is '利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.lxsrylj is '累计利息（月累计）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.lxsrnlj is '累计利息（年累计）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.lxzcrlj is '利息支出日累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.lxsrrlj is '利息收入日累计';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.brftpjsr is '本日ftp净收入';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.qylx is '签约类型';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.cph is '产品编号';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.cpejfl is '产品小类（二级分类）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.cpsjfl is '产品组（三级分类）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.cpsijfl is '基础产品（四级分类）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.cpzwmc is '可售产品（产品名称）';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_tyckzzhmx_recal.etl_timestamp is 'ETL处理时间戳';
