/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_mcht_base_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_mcht_base_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_mcht_base_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_mcht_base_inf(
    mcht_no varchar2(23) -- 商户号
    ,mcht_nm varchar2(135) -- 商户名称
    ,risl_lvl varchar2(2) -- 商户风险级别
    ,mcht_lvl varchar2(2) -- 商户级别
    ,mcht_status varchar2(2) -- 商户状态
    ,manu_auth_flag varchar2(2) -- 是否支持人工授权
    ,part_num varchar2(180) -- 商户分期期数
    ,disc_cons_flg varchar2(2) -- 折扣消费标志
    ,disc_cons_rebate varchar2(12) -- 折扣消费率
    ,pass_flag varchar2(2) -- 是否支持无磁无密交易
    ,open_days varchar2(9) -- 开展业务天数
    ,sleep_days varchar2(9) -- 连续无法交易天数
    ,mcht_cn_abbr varchar2(135) -- 中文名称简写
    ,spell_name varchar2(45) -- 商户拼音缩写
    ,eng_name varchar2(90) -- 商户英文名称
    ,mcht_en_abbr varchar2(30) -- 商户英文名称缩写
    ,area_no varchar2(9) -- 区域代码
    ,settle_area_no varchar2(6) -- 清算区域代码
    ,addr varchar2(90) -- 商户地址
    ,home_page varchar2(135) -- 公司地址
    ,mcc varchar2(6) -- 商户mcc码
    ,tcc varchar2(2) -- 商户类型码
    ,etps_attr varchar2(6) -- 企业性质
    ,mng_mcht_id varchar2(23) -- 上级商户号
    ,mcht_grp varchar2(6) -- 商户组
    ,mcht_attr varchar2(30) -- 专户商户id
    ,mcht_group_flag varchar2(2) -- 商户种类
    ,mcht_group_id varchar2(12) -- 集团商户id
    ,mcht_eng_nm varchar2(90) -- 集团商户英文名称
    ,mcht_eng_addr varchar2(90) -- 商户英文地址
    ,mcht_eng_city_name varchar2(90) -- 商户所在城市
    ,sa_limit_amt varchar2(18) -- 受控处理金额(单笔)
    ,sa_action varchar2(2) -- 受控处理动作
    ,psam_num varchar2(5) -- psam卡数量
    ,cd_mac_num varchar2(5) -- 押卡机已发数量
    ,pos_num varchar2(5) -- pos机已发数量
    ,conn_type varchar2(2) -- 连接方式
    ,mcht_mng_mode varchar2(2) -- 是否仅营业时间内交易
    ,mcht_function varchar2(45) -- 商户功能
    ,licence_no varchar2(45) -- 营业执照号码
    ,licence_end_date varchar2(12) -- 营业执照有效期
    ,bank_licence_no varchar2(30) -- 机构代码证号码
    ,bus_type varchar2(6) -- 营业性质
    ,fax_no varchar2(30) -- 税务登记证号码
    ,bus_amt varchar2(18) -- 注册资金
    ,mcht_cre_lvl varchar2(6) -- 企业资质等级
    ,contact varchar2(45) -- 联系人姓名
    ,post_code varchar2(9) -- 邮编
    ,comm_email varchar2(60) -- 联系人电子邮箱
    ,comm_mobil varchar2(27) -- 联系人手机
    ,comm_tel varchar2(27) -- 联系人电话
    ,manager varchar2(23) -- 法人姓名
    ,artif_certif_tp varchar2(6) -- 法人证件类型
    ,identity_no varchar2(68) -- 法人证件号码
    ,manager_tel varchar2(18) -- 法人联系电话
    ,fax varchar2(30) -- 传真
    ,electrofax varchar2(23) -- 电传
    ,reg_addr varchar2(135) -- 注册地址
    ,apply_date varchar2(12) -- 申请日期
    ,enable_date varchar2(12) -- 启用日期
    ,pre_aud_nm varchar2(60) -- 初审人
    ,confirm_nm varchar2(60) -- 批准人
    ,protocal_id varchar2(30) -- 协议编号
    ,sign_inst_id varchar2(20) -- 签约机构代码(银联分配机构号)
    ,net_nm varchar2(45) -- 隶属网点代码
    ,agr_br varchar2(18) -- 签约网点
    ,net_tel varchar2(27) -- 网点电话
    ,prol_date varchar2(12) -- 签约日期
    ,prol_tlr varchar2(12) -- 签约柜员
    ,close_date varchar2(12) -- 撤消签约日期
    ,close_tlr varchar2(11) -- 撤消签约柜员
    ,main_tlr varchar2(12) -- 维护柜员
    ,check_tlr varchar2(12) -- 复核柜员
    ,oper_no varchar2(18) -- 客户经理工号
    ,oper_nm varchar2(27) -- 客户经理姓名
    ,proc_flag varchar2(15) -- 业务处理标志
    ,set_cur varchar2(6) -- 外卡入账币种
    ,print_inst_id varchar2(20) -- 入账凭单打印机构
    ,acq_inst_id varchar2(20) -- 商户所属机构代码
    ,acq_bk_name varchar2(45) -- 收单行名称
    ,bank_no varchar2(14) -- 分行号
    ,orgn_no varchar2(5) -- 卡中心地区号
    ,subbrh_no varchar2(9) -- 隶属支行号
    ,subbrh_nm varchar2(45) -- 隶属支行名称
    ,open_time varchar2(9) -- 商户营业开始时间
    ,close_time varchar2(9) -- 商户营业结束时间
    ,vis_act_flg varchar2(2) -- visa外卡受理标志
    ,vis_mcht_id varchar2(23) -- visa商户号
    ,mst_act_flg varchar2(2) -- master外卡受理标志
    ,mst_mcht_id varchar2(23) -- master商户号
    ,amx_act_flg varchar2(2) -- 美运外卡受理标志
    ,amx_mcht_id varchar2(23) -- 美运商户号
    ,dnr_act_flg varchar2(2) -- 大来外卡受理标志
    ,dnr_mcht_id varchar2(23) -- 大来商户号
    ,jcb_act_flg varchar2(2) -- jcb外卡受理标志(第三方推广费用)
    ,jcb_mcht_id varchar2(23) -- jcb商户号
    ,cup_mcht_flg varchar2(2) -- 是否支持他行借记卡
    ,deb_mcht_flg varchar2(2) -- 是否支持他行贷记卡
    ,cre_mcht_flg varchar2(2) -- 是否支持本行借记卡
    ,cdc_mcht_flg varchar2(2) -- 是否支持本行贷记卡
    ,reserved varchar2(90) -- 保留
    ,upd_opr_id varchar2(60) -- 修改记录操作员
    ,crt_opr_id varchar2(60) -- 创建记录操作员
    ,rec_upd_ts varchar2(21) -- 记录修改时间
    ,rec_crt_ts varchar2(21) -- 记录创建时间
    ,install_tel varchar2(27) -- 装机人电话
    ,mcht_grade varchar2(12) -- 商户评级 计算评分
    ,reserved1 varchar2(48) -- 商户评级信息
    ,reserved2 varchar2(96) -- 保留字段
    ,integral_method varchar2(2) -- 积分累计方式
    ,integral_rate number(16,3) -- 消费积分比率
    ,integral_fee_limit number(15,2) -- 累计积分限额
    ,integral_number number(22) -- 按笔累计积分
    ,acct_flag varchar2(2) -- 暂缓入账标识
    ,is_auto_check_level varchar2(2) -- 是否自动评级
    ,level1 varchar2(2) -- 
    ,level2 varchar2(2) -- 
    ,level3 varchar2(2) -- 
    ,level4 varchar2(2) -- 
    ,level5 varchar2(2) -- 
    ,mcht_sync_status varchar2(2) -- 
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
grant select on ${iol_schema}.mrms_tbl_mcht_base_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_base_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_base_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_base_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_mcht_base_inf is '商户基础信息表';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_no is '商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_nm is '商户名称';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.risl_lvl is '商户风险级别';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_lvl is '商户级别';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_status is '商户状态';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.manu_auth_flag is '是否支持人工授权';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.part_num is '商户分期期数';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.disc_cons_flg is '折扣消费标志';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.disc_cons_rebate is '折扣消费率';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.pass_flag is '是否支持无磁无密交易';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.open_days is '开展业务天数';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.sleep_days is '连续无法交易天数';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_cn_abbr is '中文名称简写';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.spell_name is '商户拼音缩写';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.eng_name is '商户英文名称';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_en_abbr is '商户英文名称缩写';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.area_no is '区域代码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.settle_area_no is '清算区域代码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.addr is '商户地址';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.home_page is '公司地址';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcc is '商户mcc码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.tcc is '商户类型码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.etps_attr is '企业性质';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mng_mcht_id is '上级商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_grp is '商户组';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_attr is '专户商户id';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_group_flag is '商户种类';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_group_id is '集团商户id';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_eng_nm is '集团商户英文名称';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_eng_addr is '商户英文地址';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_eng_city_name is '商户所在城市';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.sa_limit_amt is '受控处理金额(单笔)';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.sa_action is '受控处理动作';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.psam_num is 'psam卡数量';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.cd_mac_num is '押卡机已发数量';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.pos_num is 'pos机已发数量';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.conn_type is '连接方式';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_mng_mode is '是否仅营业时间内交易';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_function is '商户功能';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.licence_no is '营业执照号码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.licence_end_date is '营业执照有效期';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.bank_licence_no is '机构代码证号码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.bus_type is '营业性质';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.fax_no is '税务登记证号码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.bus_amt is '注册资金';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_cre_lvl is '企业资质等级';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.contact is '联系人姓名';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.post_code is '邮编';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.comm_email is '联系人电子邮箱';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.comm_mobil is '联系人手机';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.comm_tel is '联系人电话';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.manager is '法人姓名';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.artif_certif_tp is '法人证件类型';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.identity_no is '法人证件号码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.manager_tel is '法人联系电话';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.fax is '传真';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.electrofax is '电传';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.reg_addr is '注册地址';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.apply_date is '申请日期';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.enable_date is '启用日期';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.pre_aud_nm is '初审人';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.confirm_nm is '批准人';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.protocal_id is '协议编号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.sign_inst_id is '签约机构代码(银联分配机构号)';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.net_nm is '隶属网点代码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.agr_br is '签约网点';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.net_tel is '网点电话';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.prol_date is '签约日期';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.prol_tlr is '签约柜员';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.close_date is '撤消签约日期';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.close_tlr is '撤消签约柜员';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.main_tlr is '维护柜员';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.check_tlr is '复核柜员';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.oper_no is '客户经理工号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.oper_nm is '客户经理姓名';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.proc_flag is '业务处理标志';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.set_cur is '外卡入账币种';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.print_inst_id is '入账凭单打印机构';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.acq_inst_id is '商户所属机构代码';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.acq_bk_name is '收单行名称';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.bank_no is '分行号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.orgn_no is '卡中心地区号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.subbrh_no is '隶属支行号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.subbrh_nm is '隶属支行名称';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.open_time is '商户营业开始时间';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.close_time is '商户营业结束时间';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.vis_act_flg is 'visa外卡受理标志';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.vis_mcht_id is 'visa商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mst_act_flg is 'master外卡受理标志';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mst_mcht_id is 'master商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.amx_act_flg is '美运外卡受理标志';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.amx_mcht_id is '美运商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.dnr_act_flg is '大来外卡受理标志';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.dnr_mcht_id is '大来商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.jcb_act_flg is 'jcb外卡受理标志(第三方推广费用)';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.jcb_mcht_id is 'jcb商户号';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.cup_mcht_flg is '是否支持他行借记卡';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.deb_mcht_flg is '是否支持他行贷记卡';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.cre_mcht_flg is '是否支持本行借记卡';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.cdc_mcht_flg is '是否支持本行贷记卡';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.reserved is '保留';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.upd_opr_id is '修改记录操作员';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.crt_opr_id is '创建记录操作员';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.rec_upd_ts is '记录修改时间';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.rec_crt_ts is '记录创建时间';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.install_tel is '装机人电话';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_grade is '商户评级 计算评分';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.reserved1 is '商户评级信息';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.reserved2 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.integral_method is '积分累计方式';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.integral_rate is '消费积分比率';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.integral_fee_limit is '累计积分限额';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.integral_number is '按笔累计积分';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.acct_flag is '暂缓入账标识';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.is_auto_check_level is '是否自动评级';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.level1 is '';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.level2 is '';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.level3 is '';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.level4 is '';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.level5 is '';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.mcht_sync_status is '';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_mcht_base_inf.etl_timestamp is 'ETL处理时间戳';
