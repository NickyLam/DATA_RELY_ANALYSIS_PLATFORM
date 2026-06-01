/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_lsb_dkzh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_lsb_dkzh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_lsb_dkzh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_lsb_dkzh(
    jxdxdh number(22,0) -- 绩效对象代号
    ,tjrq number(22,0) -- 统计日期
    ,zhdh varchar2(60) -- 账号ID
    ,zzh varchar2(150) -- 子账号
    ,zhhm varchar2(300) -- 账户名称
    ,bz varchar2(5) -- 币种
    ,cph varchar2(30) -- 产品号
    ,kmh varchar2(30) -- 科目号
    ,yqkm varchar2(30) -- 逾期科目
    ,daizhikm varchar2(30) -- 
    ,daizhangkm varchar2(30) -- 呆账科目
    ,fhdh varchar2(15) -- 分行代号
    ,jgdh varchar2(15) -- 财务归属机构号
    ,khh varchar2(45) -- 客户号
    ,khrq number(22,0) -- 开户日期
    ,ffrq number(22,0) -- 发放日期
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zhzt varchar2(3) -- 账户状态
    ,qx varchar2(8) -- 期限
    ,lldh varchar2(30) -- 利率代号
    ,nll number(15,7) -- 年利率
    ,llyhbz varchar2(2) -- 利率浮动标志
    ,llyhbl number(18,6) -- 利率浮动比例
    ,pjh varchar2(60) -- 票据号
    ,hth varchar2(75) -- 合同号
    ,dkfs varchar2(3) -- 贷款方式
    ,dkje number(25,4) -- 贷款金额
    ,zhye number(25,4) -- 账户余额
    ,zcye number(25,4) -- 正常余额
    ,yqye number(25,4) -- 逾期余额
    ,daizhiye number(25,4) -- 
    ,daizhangye number(25,4) -- 呆账余额
    ,yswslx number(25,4) -- 应收未收利息
    ,bzjbl number(18,2) -- 保证金比例
    ,hydh varchar2(18) -- 核心填写工号
    ,zhbs varchar2(2) -- 账户标识：1-对公，2-对私
    ,txbz varchar2(2) -- 停息标志
    ,czyh varchar2(18) -- 操作用户
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,khdkje number(25,4) -- 客户贷款金额
    ,khdkye number(25,4) -- 客户贷款余额
    ,qygm varchar2(3) -- 企业规模
    ,gdzl varchar2(15) -- 个贷种类
    ,sjfl varchar2(3) -- 四级分类
    ,wjfl varchar2(2) -- 五级分类
    ,ffbs varchar2(2) -- 发放标识
    ,dqbs varchar2(2) -- 定期标识
    ,zhyeqj varchar2(45) -- 帐户余额区间
    ,khyeqj varchar2(45) -- 客户余额区间
    ,dkjeqj varchar2(45) -- 贷款金额区间
    ,khjeqj varchar2(45) -- 客户金额区间
    ,yqtsqj varchar2(45) -- 逾期天数区间
    ,zrdkjeqj varchar2(45) -- 责任贷款金额区间
    ,xcbldkbs varchar2(45) -- 形成不良贷款标识
    ,xwdkbs varchar2(2) -- 小微贷款标识
    ,sndkbs varchar2(2) -- 涉农贷款标识
    ,xcdkbs varchar2(3) -- 瑕疵贷款标识
    ,yxblbs varchar2(3) -- 隐形不良标识
    ,ncwjfl varchar2(2) -- 年初五级分类
    ,qxtsqj varchar2(45) -- 起息天数区间
    ,ncqxtsqj varchar2(45) -- 年初欠息天数区间
    ,llqj varchar2(45) -- 利率区间
    ,zgdkbs varchar2(3) -- 职工贷款标识
    ,stdkbs varchar2(3) -- 
    ,fpdkbs varchar2(3) -- 扶贫贷款标识
    ,mzdkbs varchar2(3) -- 民政贷款标识
    ,qxbs varchar2(3) -- 欠息标识
    ,yswslxqj varchar2(45) -- 应收未收利息区间
    ,ywpz varchar2(30) -- 业务凭证
    ,dkxz varchar2(3) -- 贷款性质
    ,zyqrq number(22,0) -- 转逾期日期
    ,zfyjrq number(22,0) -- 转非应计日期
    ,dkfflb varchar2(45) -- 贷款发放类别
    ,hkfs varchar2(6) -- 还款方式
    ,bjyqts number(22,0) -- 本金逾期天数
    ,lxyqts number(22,0) -- 利息逾期天数
    ,jxfs varchar2(3) -- 计息方式
    ,sxed number(25,4) -- 
    ,qynll number(15,7) -- 逾期年利率
    ,khkhbs varchar2(3) -- 客户开卡标识
    ,xcfyjdkbs varchar2(3) -- 
    ,xcyqdkbs varchar2(3) -- 形成逾期贷款标识
    ,bmkkh varchar2(60) -- 便民卡卡号
    ,zhjrjye number(25,4) -- 账户季日均余额
    ,zhyrjye number(25,4) -- 账户月日均余额
    ,lxdbs varchar2(6) -- 类信贷标识
    ,hxbz varchar2(2) -- 核销标志
    ,lsdkbs varchar2(3) -- 绿色贷款标识
    ,xsbz varchar2(3) -- 
    ,jqrq number(22,0) -- 结清日期
    ,sfzydk varchar2(2) -- 是否转移贷款
    ,fdbptdk varchar2(2) -- 非打包平台贷款
    ,ypbzjblqj varchar2(5) -- 押品类低风险比例区间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_lsb_dkzh to ${iml_schema};
grant select on ${iol_schema}.pams_lsb_dkzh to ${icl_schema};
grant select on ${iol_schema}.pams_lsb_dkzh to ${idl_schema};
grant select on ${iol_schema}.pams_lsb_dkzh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_lsb_dkzh is '临时表-贷款账户表';
comment on column ${iol_schema}.pams_lsb_dkzh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_lsb_dkzh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_lsb_dkzh.zhdh is '账号ID';
comment on column ${iol_schema}.pams_lsb_dkzh.zzh is '子账号';
comment on column ${iol_schema}.pams_lsb_dkzh.zhhm is '账户名称';
comment on column ${iol_schema}.pams_lsb_dkzh.bz is '币种';
comment on column ${iol_schema}.pams_lsb_dkzh.cph is '产品号';
comment on column ${iol_schema}.pams_lsb_dkzh.kmh is '科目号';
comment on column ${iol_schema}.pams_lsb_dkzh.yqkm is '逾期科目';
comment on column ${iol_schema}.pams_lsb_dkzh.daizhikm is '';
comment on column ${iol_schema}.pams_lsb_dkzh.daizhangkm is '呆账科目';
comment on column ${iol_schema}.pams_lsb_dkzh.fhdh is '分行代号';
comment on column ${iol_schema}.pams_lsb_dkzh.jgdh is '财务归属机构号';
comment on column ${iol_schema}.pams_lsb_dkzh.khh is '客户号';
comment on column ${iol_schema}.pams_lsb_dkzh.khrq is '开户日期';
comment on column ${iol_schema}.pams_lsb_dkzh.ffrq is '发放日期';
comment on column ${iol_schema}.pams_lsb_dkzh.qxrq is '起息日期';
comment on column ${iol_schema}.pams_lsb_dkzh.dqrq is '到期日期';
comment on column ${iol_schema}.pams_lsb_dkzh.xhrq is '销户日期';
comment on column ${iol_schema}.pams_lsb_dkzh.zhzt is '账户状态';
comment on column ${iol_schema}.pams_lsb_dkzh.qx is '期限';
comment on column ${iol_schema}.pams_lsb_dkzh.lldh is '利率代号';
comment on column ${iol_schema}.pams_lsb_dkzh.nll is '年利率';
comment on column ${iol_schema}.pams_lsb_dkzh.llyhbz is '利率浮动标志';
comment on column ${iol_schema}.pams_lsb_dkzh.llyhbl is '利率浮动比例';
comment on column ${iol_schema}.pams_lsb_dkzh.pjh is '票据号';
comment on column ${iol_schema}.pams_lsb_dkzh.hth is '合同号';
comment on column ${iol_schema}.pams_lsb_dkzh.dkfs is '贷款方式';
comment on column ${iol_schema}.pams_lsb_dkzh.dkje is '贷款金额';
comment on column ${iol_schema}.pams_lsb_dkzh.zhye is '账户余额';
comment on column ${iol_schema}.pams_lsb_dkzh.zcye is '正常余额';
comment on column ${iol_schema}.pams_lsb_dkzh.yqye is '逾期余额';
comment on column ${iol_schema}.pams_lsb_dkzh.daizhiye is '';
comment on column ${iol_schema}.pams_lsb_dkzh.daizhangye is '呆账余额';
comment on column ${iol_schema}.pams_lsb_dkzh.yswslx is '应收未收利息';
comment on column ${iol_schema}.pams_lsb_dkzh.bzjbl is '保证金比例';
comment on column ${iol_schema}.pams_lsb_dkzh.hydh is '核心填写工号';
comment on column ${iol_schema}.pams_lsb_dkzh.zhbs is '账户标识：1-对公，2-对私';
comment on column ${iol_schema}.pams_lsb_dkzh.txbz is '停息标志';
comment on column ${iol_schema}.pams_lsb_dkzh.czyh is '操作用户';
comment on column ${iol_schema}.pams_lsb_dkzh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_lsb_dkzh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_lsb_dkzh.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_lsb_dkzh.khdkje is '客户贷款金额';
comment on column ${iol_schema}.pams_lsb_dkzh.khdkye is '客户贷款余额';
comment on column ${iol_schema}.pams_lsb_dkzh.qygm is '企业规模';
comment on column ${iol_schema}.pams_lsb_dkzh.gdzl is '个贷种类';
comment on column ${iol_schema}.pams_lsb_dkzh.sjfl is '四级分类';
comment on column ${iol_schema}.pams_lsb_dkzh.wjfl is '五级分类';
comment on column ${iol_schema}.pams_lsb_dkzh.ffbs is '发放标识';
comment on column ${iol_schema}.pams_lsb_dkzh.dqbs is '定期标识';
comment on column ${iol_schema}.pams_lsb_dkzh.zhyeqj is '帐户余额区间';
comment on column ${iol_schema}.pams_lsb_dkzh.khyeqj is '客户余额区间';
comment on column ${iol_schema}.pams_lsb_dkzh.dkjeqj is '贷款金额区间';
comment on column ${iol_schema}.pams_lsb_dkzh.khjeqj is '客户金额区间';
comment on column ${iol_schema}.pams_lsb_dkzh.yqtsqj is '逾期天数区间';
comment on column ${iol_schema}.pams_lsb_dkzh.zrdkjeqj is '责任贷款金额区间';
comment on column ${iol_schema}.pams_lsb_dkzh.xcbldkbs is '形成不良贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.sndkbs is '涉农贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.xcdkbs is '瑕疵贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.yxblbs is '隐形不良标识';
comment on column ${iol_schema}.pams_lsb_dkzh.ncwjfl is '年初五级分类';
comment on column ${iol_schema}.pams_lsb_dkzh.qxtsqj is '起息天数区间';
comment on column ${iol_schema}.pams_lsb_dkzh.ncqxtsqj is '年初欠息天数区间';
comment on column ${iol_schema}.pams_lsb_dkzh.llqj is '利率区间';
comment on column ${iol_schema}.pams_lsb_dkzh.zgdkbs is '职工贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.stdkbs is '';
comment on column ${iol_schema}.pams_lsb_dkzh.fpdkbs is '扶贫贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.mzdkbs is '民政贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.qxbs is '欠息标识';
comment on column ${iol_schema}.pams_lsb_dkzh.yswslxqj is '应收未收利息区间';
comment on column ${iol_schema}.pams_lsb_dkzh.ywpz is '业务凭证';
comment on column ${iol_schema}.pams_lsb_dkzh.dkxz is '贷款性质';
comment on column ${iol_schema}.pams_lsb_dkzh.zyqrq is '转逾期日期';
comment on column ${iol_schema}.pams_lsb_dkzh.zfyjrq is '转非应计日期';
comment on column ${iol_schema}.pams_lsb_dkzh.dkfflb is '贷款发放类别';
comment on column ${iol_schema}.pams_lsb_dkzh.hkfs is '还款方式';
comment on column ${iol_schema}.pams_lsb_dkzh.bjyqts is '本金逾期天数';
comment on column ${iol_schema}.pams_lsb_dkzh.lxyqts is '利息逾期天数';
comment on column ${iol_schema}.pams_lsb_dkzh.jxfs is '计息方式';
comment on column ${iol_schema}.pams_lsb_dkzh.sxed is '';
comment on column ${iol_schema}.pams_lsb_dkzh.qynll is '逾期年利率';
comment on column ${iol_schema}.pams_lsb_dkzh.khkhbs is '客户开卡标识';
comment on column ${iol_schema}.pams_lsb_dkzh.xcfyjdkbs is '';
comment on column ${iol_schema}.pams_lsb_dkzh.xcyqdkbs is '形成逾期贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.bmkkh is '便民卡卡号';
comment on column ${iol_schema}.pams_lsb_dkzh.zhjrjye is '账户季日均余额';
comment on column ${iol_schema}.pams_lsb_dkzh.zhyrjye is '账户月日均余额';
comment on column ${iol_schema}.pams_lsb_dkzh.lxdbs is '类信贷标识';
comment on column ${iol_schema}.pams_lsb_dkzh.hxbz is '核销标志';
comment on column ${iol_schema}.pams_lsb_dkzh.lsdkbs is '绿色贷款标识';
comment on column ${iol_schema}.pams_lsb_dkzh.xsbz is '';
comment on column ${iol_schema}.pams_lsb_dkzh.jqrq is '结清日期';
comment on column ${iol_schema}.pams_lsb_dkzh.sfzydk is '是否转移贷款';
comment on column ${iol_schema}.pams_lsb_dkzh.fdbptdk is '非打包平台贷款';
comment on column ${iol_schema}.pams_lsb_dkzh.ypbzjblqj is '押品类低风险比例区间';
comment on column ${iol_schema}.pams_lsb_dkzh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_lsb_dkzh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_lsb_dkzh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_lsb_dkzh.etl_timestamp is 'ETL处理时间戳';
