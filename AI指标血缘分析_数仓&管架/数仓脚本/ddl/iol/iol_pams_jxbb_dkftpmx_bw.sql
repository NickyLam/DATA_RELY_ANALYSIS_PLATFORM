/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dkftpmx_bw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dkftpmx_bw
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dkftpmx_bw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dkftpmx_bw(
    tjrq number(22,0) -- 统计日期
    ,khm varchar2(150) -- 客户名
    ,khh varchar2(150) -- 客户号
    ,khjgkhdxdh number(22,0) -- 开户机构考核对象代号
    ,khjgh varchar2(150) -- 开户机构号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,ssjgkhdxdh number(22,0) -- 所属机构考核对象代号
    ,ssjgh varchar2(150) -- 所属机构号
    ,ssjgmc varchar2(150) -- 所属机构名称
    ,khjlgh varchar2(150) -- 客户经理工号
    ,khjlxm varchar2(150) -- 客户经理名称
    ,fpbl number(19,5) -- 分配比例
    ,zhbs varchar2(150) -- 账户标识
    ,xwdkbs varchar2(150) -- 小微贷款标识
    ,jjh varchar2(150) -- 借据号
    ,jjzt varchar2(150) -- 借据状态
    ,dqzxll number(38,8) -- 当前执行利率
    ,jzll number(38,8) -- 基准利率
    ,fdbl number(25,4) -- 浮动比率
    ,fdfs varchar2(150) -- 浮动方式
    ,kmh varchar2(150) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,cpbh varchar2(150) -- 产品编号
    ,cpejfl varchar2(150) -- 产品二级分类
    ,cpsjfl varchar2(150) -- 产品四级分类
    ,cpsijfl varchar2(150) -- 产品四级分类
    ,cpzwmc varchar2(150) -- 产品中文名称
    ,sfxw varchar2(150) -- 是否小微
    ,qx varchar2(150) -- 期限
    ,fkr number(22,0) -- 放款日
    ,dqr number(22,0) -- 到期日期
    ,bz varchar2(150) -- 币种
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,ftpjg number(25,4) -- ftp价格
    ,dyftpzycb number(25,4) -- 当月ftp转移成本
    ,ljftpzycb number(25,4) -- 累计ftp转移成本
    ,dyftpjsy number(25,4) -- 当月ftp净收益
    ,ljftpjsy number(25,4) -- 累计ftp净收益
    ,ftplxsr number(25,4) -- ftp利息收入
    ,ftpzycb number(25,4) -- ftp转移成本
    ,ftpsy number(25,4) -- ftp收益
    ,pjh varchar2(60) -- 票据号
    ,wjfl varchar2(8) -- 五级分类
    ,yqxyss number(26,5) -- 预计信用损失
    ,lxkm varchar2(75) -- 利息科目
    ,lxkmmc varchar2(150) -- 利息科目名称
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,bzdm varchar2(15) -- 币种代码
    ,fptx varchar2(15) -- 分配条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,zjtxbz varchar2(15) -- 
    ,dkje number(25,4) -- 贷款金额
    ,jrj number(25,4) -- 季日均
    ,jlx number(25,4) -- 季利息
    ,djftpzycb number(25,4) -- 当季FTP转移成本累计
    ,djftpjsy number(25,4) -- 当季FTP净收益累计
    ,bwbs varchar2(2) -- 表外标识
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
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bw to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bw to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bw to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bw to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dkftpmx_bw is '绩效报表_贷款FTP明细_表外';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.khm is '客户名';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ssjgh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.khjlxm is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.jjzt is '借据状态';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.dqzxll is '当前执行利率';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.fdbl is '浮动比率';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.fdfs is '浮动方式';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.cpzwmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.sfxw is '是否小微';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.fkr is '放款日';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ftpjg is 'ftp价格';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.dyftpzycb is '当月ftp转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ljftpzycb is '累计ftp转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.dyftpjsy is '当月ftp净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ljftpjsy is '累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ftplxsr is 'ftp利息收入';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ftpzycb is 'ftp转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.ftpsy is 'ftp收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.pjh is '票据号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.yqxyss is '预计信用损失';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.fptx is '分配条线';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.zjtxbz is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.dkje is '贷款金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.jlx is '季利息';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.djftpzycb is '当季FTP转移成本累计';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.djftpjsy is '当季FTP净收益累计';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.bwbs is '表外标识';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bw.etl_timestamp is 'ETL处理时间戳';
