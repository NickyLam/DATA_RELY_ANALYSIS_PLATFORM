/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_ibo_deal
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ctms_fbs_v_ibo_deal_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ctms_fbs_v_ibo_deal');
  
  if v_var <> 0 then 
    execute immediate 'alter table ctms_fbs_v_ibo_deal drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ctms_fbs_v_ibo_deal add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */into ${iol_schema}.ctms_fbs_v_ibo_deal(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,crncy_code -- 货币
            ,rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
            ,first_amnt -- 拆借金额，负数为拆出，正数为拆入
            ,maturity_amnt -- 期末结算金额
            ,day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
            ,rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
            ,interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
            ,current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
            ,accrued_amnt -- 应计利息总额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手的srno
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
            ,trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
            ,deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
            ,deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合id
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
            ,portfolio_link_sqno -- 交易链接编号
            ,ibo_type -- 拆借类型 0：拆借 1：同存
            ,clear_dep -- 清算机构 zz：其它； aa：上清所
            ,rsdl_amnt -- 剩余金额
            ,float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
            ,intrst_bnchmrk_srno -- 浮动利率指标
            ,intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
            ,intrst_term -- 利率期限
            ,spread_rate -- bp，带方向
            ,pmnt_freq -- 付息频率
            ,pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
            ,unwind_cnfrm_rate -- 约定提前支取利率。
            ,fixing_freq -- 定息频率
            ,fixing_day_count -- 定价日调整天数
            ,frst_pmnt_date -- 首次付息日
            ,day_count -- 拆借天数
            ,imps_rate -- 约定罚息日利率(影响后台)。
            ,usd_crncy_amnt -- 折usd货币金额
            ,event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_date -- 事件日期
            ,ro_roll_type -- 展期方式
            ,ro_calc_amount -- 展期本金
            ,ro_intrst_amount -- 展期利息
            ,confirm_indc -- 交易后确认标识
            ,collateral_method -- 质押方式 1：买断 2：质押
            ,delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
            ,delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
            ,underlying_currency -- 债券币种
            ,underlying_stip_value -- 折算比例
            ,underlying_discountamt -- 折算金额1
            ,underlying_qty -- 券面总额
            ,underlying_securityid -- 债券代码
            ,underlying_dirty_price -- 债券全价
            ,underlying_value -- 债券价值
            ,face_value -- 面值
            ,underlying_stip_rate -- 折算汇率2
            ,underlying_discountamt2 -- 折算金额2
            ,remark -- 备注
            ,ma_bank_cn -- 本方经办行中文名称
            ,ma_bank_en -- 本方经办行英文名称
            ,cp_ma_bank_cn -- 对手方经办行中文名称
            ,cp_ma_bank_en -- 对手方经办行英文名称
            ,dealer -- 交易员
            ,delivery_type_ibo -- 结算方式 13: siss 支付直连
            ,deal_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,crncy_code -- 货币
            ,rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
            ,first_amnt -- 拆借金额，负数为拆出，正数为拆入
            ,maturity_amnt -- 期末结算金额
            ,day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
            ,rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
            ,interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
            ,current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
            ,accrued_amnt -- 应计利息总额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手的srno
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
            ,trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
            ,deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
            ,deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合id
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
            ,portfolio_link_sqno -- 交易链接编号
            ,ibo_type -- 拆借类型 0：拆借 1：同存
            ,clear_dep -- 清算机构 zz：其它； aa：上清所
            ,rsdl_amnt -- 剩余金额
            ,float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
            ,intrst_bnchmrk_srno -- 浮动利率指标
            ,intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
            ,intrst_term -- 利率期限
            ,spread_rate -- bp，带方向
            ,pmnt_freq -- 付息频率
            ,pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
            ,unwind_cnfrm_rate -- 约定提前支取利率。
            ,fixing_freq -- 定息频率
            ,fixing_day_count -- 定价日调整天数
            ,frst_pmnt_date -- 首次付息日
            ,day_count -- 拆借天数
            ,imps_rate -- 约定罚息日利率(影响后台)。
            ,usd_crncy_amnt -- 折usd货币金额
            ,event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_date -- 事件日期
            ,ro_roll_type -- 展期方式
            ,ro_calc_amount -- 展期本金
            ,ro_intrst_amount -- 展期利息
            ,confirm_indc -- 交易后确认标识
            ,collateral_method -- 质押方式 1：买断 2：质押
            ,delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
            ,delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
            ,underlying_currency -- 债券币种
            ,underlying_stip_value -- 折算比例
            ,underlying_discountamt -- 折算金额1
            ,underlying_qty -- 券面总额
            ,underlying_securityid -- 债券代码
            ,underlying_dirty_price -- 债券全价
            ,underlying_value -- 债券价值
            ,face_value -- 面值
            ,underlying_stip_rate -- 折算汇率2
            ,underlying_discountamt2 -- 折算金额2
            ,remark -- 备注
            ,ma_bank_cn -- 本方经办行中文名称
            ,ma_bank_en -- 本方经办行英文名称
            ,cp_ma_bank_cn -- 对手方经办行中文名称
            ,cp_ma_bank_en -- 对手方经办行英文名称
            ,dealer -- 交易员
            ,delivery_type_ibo -- 结算方式 13: siss 支付直连
            ,to_date('00010101','yyyymmdd') as deal_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ctms_fbs_v_ibo_deal_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
