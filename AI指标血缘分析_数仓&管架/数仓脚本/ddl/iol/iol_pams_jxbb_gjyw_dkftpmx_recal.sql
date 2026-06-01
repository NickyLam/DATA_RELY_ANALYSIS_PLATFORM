/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_gjyw_dkftpmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal(
    tjrq number -- 统计日期
    ,jjh varchar2(300) -- 借据号
    ,khmc varchar2(300) -- 客户名
    ,khh varchar2(300) -- 客户号
    ,fhjgdh varchar2(300) -- 分行机构号
    ,fhjgmc varchar2(300) -- 分行机构名称
    ,khjgdh varchar2(300) -- 开户机构号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,ssjgdh varchar2(300) -- 所属机构号
    ,ssjgmc varchar2(300) -- 所属机构名称
    ,hydh varchar2(300) -- 客户经理工号
    ,hymc varchar2(300) -- 客户经理名称
    ,fpbl number(19,5) -- 分配比例
    ,zxll number(38,8) -- 当前执行利率
    ,jzll number(38,8) -- 基准利率
    ,fdbl number(25,4) -- 浮动比率
    ,fdfs varchar2(300) -- 浮动方式
    ,kmh varchar2(300) -- 科目号
    ,kmmc varchar2(300) -- 科目名称
    ,lxkmh varchar2(150) -- 利息科目
    ,lxkmmc varchar2(300) -- 利息科目名称
    ,cpbh varchar2(300) -- 产品编号
    ,cpejfl varchar2(300) -- 产品二级分类
    ,cpsjfl varchar2(300) -- 产品四级分类
    ,cpsijfl varchar2(300) -- 产品四级分类
    ,cpmc varchar2(300) -- 产品中文名称
    ,sfxw varchar2(300) -- 是否小微
    ,qx varchar2(300) -- 期限
    ,fkrq number -- 放款日
    ,dqrq number -- 到期日期
    ,bzmc varchar2(300) -- 币种（中文）
    ,dkje_yb number(25,4) -- 发放金额(原币）
    ,dkje number(25,5) -- 发放金额（折合人民币）
    ,zhye_yb number(25,6) -- 余额(原币）
    ,zhye number(25,7) -- 余额（折合人民币）
    ,yrj number(25,4) -- 月日均
    ,jrj number(25,4) -- 季日均
    ,nrj number(25,4) -- 年日均
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,ftpjg number(25,4) -- FTP价格
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,dyftpjsy number(25,4) -- 当月FTP净收益
    ,djftpjsy number(25,4) -- 当季FTP净收益
    ,dnftpjsy number(25,4) -- 当年FTP净收益
    ,lsljftpjsy number(25,4) -- 历史累计FTP净收益
    ,bwbs varchar2(30) -- 表内外标识
    ,recal_dt number -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal is '绩效报表_国际业务_贷款ftp明细_重算';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.khmc is '客户名';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.fhjgdh is '分行机构号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.fhjgmc is '分行机构名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.khjgdh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.hydh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.hymc is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.zxll is '当前执行利率';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.fdbl is '浮动比率';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.fdfs is '浮动方式';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.lxkmh is '利息科目';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.cpmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.sfxw is '是否小微';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.fkrq is '放款日';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.bzmc is '币种（中文）';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.dkje_yb is '发放金额(原币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.dkje is '发放金额（折合人民币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.zhye_yb is '余额(原币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.zhye is '余额（折合人民币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.djftpjsy is '当季FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.dnftpjsy is '当年FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.lsljftpjsy is '历史累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.bwbs is '表内外标识';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_gjyw_dkftpmx_recal.etl_timestamp is 'ETL处理时间戳';
